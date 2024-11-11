namespace FreeType.UsageExample;


using System;
using System.Collections;
using System.Diagnostics;

using FreeType;


extension FreeType
{
	public class FontAtlas
	{
		public Dictionary<char32, Glyph> mGlyphs;
	
		public float mPointSize;
		public float mLineHeight;
		public float mAscent;
		public float mDescent;
		public float mMaxAdvance;


		public Response Initialize (Self.Description description, Image image)
		{
			FontFace fontFace = description.mFontFace;
			fontFace.SetSize(description.mPointSize);

			this.mPointSize = description.mPointSize;
			this.mLineHeight = description.mFontFace.mLineHeight;
			this.mAscent = description.mFontFace.mAscent;
			this.mDescent = description.mFontFace.mDescent;

			String characterSet = Self.ParseCharacterSet(description.mCharacterSets, .. scope String());
			Package package = Package(fontFace, description.mRenderMode, characterSet);
			defer { package.Dispose(); }

			int countMissingGlyphs = 0;
			for (uint32 n = 0; n < characterSet.Length; n++)
			{
				char32 unicode = characterSet.GetChar32(n).c;

				if (this.GenerateGlyph(unicode, package) == false)
				{
					countMissingGlyphs++;
					continue;
				}
			}

			if (countMissingGlyphs > 0)
				Debug.Warning!(scope $"Unable to find {countMissingGlyphs} glyph(s) specified in character set.");

			this.PackSprites(package.mSprites, image, 0).Resolve!();
			this.RetrieveKernings(fontFace);
			this.BlitToAtlas(package.mSprites, image);

			// Include whitespace into the glyph collection
			this.GenerateGlyph(char32(' '), package);

			return .Ok;
		}


		bool GenerateGlyph (char32 unicode, Package package)
		{
			var fontFace = package.mFontFace;

			var glyphIndex = FT_Get_Char_Index(fontFace.mHandle, .(unicode));
			if (glyphIndex == 0)
				return false;

			FT_Load_Char(fontFace.mHandle, .(unicode), .FT_LOAD_DEFAULT).Check!();

			var slot = fontFace.mHandle.glyph;

			var glyph = Glyph()
			{
				mIndex = glyphIndex,
				mUnicode = unicode,

				mAdvanceWidth = slot.advance.x >> 6,
				mAdvanceHeight = slot.advance.y >> 6,
				mOffestLeft = slot.bitmap_left,
				mOffsetTop = slot.bitmap_top,
				mPixelCoords = int[4] (0, 0, slot.bitmap.width, slot.bitmap.rows),

				mKernings = new Dictionary<char32, Kerning>(),
			};

			Sprite sprite = Sprite(glyph.mUnicode, glyph.mPixelCoords[2], glyph.mPixelCoords[3], 1);

			FT_Render_Glyph(fontFace.mHandle.glyph, package.mRenderMode).Check!();

			if (package.mRenderMode == .FT_RENDER_MODE_SDF)
			{
				Image.Resize(sprite.mImage, fontFace.mHandle.glyph.bitmap.width, fontFace.mHandle.glyph.bitmap.rows);
				glyph.mPixelCoords[2] = sprite.mImage.mWidth;
				glyph.mPixelCoords[3] = sprite.mImage.mHeight;
			}

			Image.Blit(fontFace.mHandle.glyph, sprite.mImage);

			this.mGlyphs.Add(unicode, glyph);
			package.mSprites.Add(sprite);

			return true;
		}

	
		Response PackSprites (List<Sprite> sprites, Image atlas, int margin)
		{
			sprites.Sort(scope (lhs, rhs) => { return (lhs.mImage.mHeight <=> rhs.mImage.mHeight); });
	
			int x = margin;
			int y = margin;
			int widestRow = 0;
			int rowHeight = 0;
			int doubleMargin = margin * 2;
	
			int maxWidth = atlas.mWidth;
			int maxHeight = atlas.mHeight;
	
	
			void Pack (Image image, ref Glyph glyph, int imageIdx)
			{
				int width = image.mWidth + doubleMargin;
				int height = image.mHeight + doubleMargin;
	
				if (x + width <= maxWidth)
				{
					glyph.mPixelCoords[0] = x + margin;
					glyph.mPixelCoords[1] = y;
					
					x += width;
	
					widestRow = Math.Max(widestRow, x);
					rowHeight = Math.Max(rowHeight, height);
				}
				else
				{
					glyph.mPixelCoords[0] = margin;
					glyph.mPixelCoords[1] = y + rowHeight + margin;
	
					x = width;
					y += rowHeight;
	
					widestRow = Math.Max(widestRow, x);
					rowHeight = height;
				}
	
				glyph.mTexCoords = float[4] (
					float(glyph.mPixelCoords[0]) / float(atlas.mWidth),
					float(glyph.mPixelCoords[1]) / float(atlas.mHeight),
					float(glyph.mPixelCoords[2]) / float(atlas.mWidth),
					float(glyph.mPixelCoords[3]) / float(atlas.mHeight)
				);
			}
	
			for (uint32 n = 0; n < sprites.Count; n++)
			{
				Sprite sprite = sprites[n];
				ref Glyph glyph = ref this.mGlyphs[sprite.mUnicode];
	
				Pack(sprite.mImage, ref glyph, imageIdx: 0);
			}
	
			if (widestRow > maxWidth || y+rowHeight > maxHeight)
			{
				return new Error()..AppendF(
					"Failed to pack glyphs into atlas. Atlas size: {}x{}; Suggested size: {}x{}",
					atlas.mWidth, atlas.mHeight,
					widestRow, y+rowHeight
				);
			}
	
			return .Ok;
		}


		void RetrieveKernings (FontFace fontFace)
		{
			FT_Err response = .FT_Err_Ok;

			for (var lhs in this.mGlyphs)
			{
				Glyph glyph = lhs.value;

				for (var rhs in this.mGlyphs)
				{
					response = FT_Get_Kerning(fontFace.mHandle, lhs.value.mIndex, rhs.value.mIndex, .FT_KERNING_DEFAULT, var vector);
					if (response != .FT_Err_Ok)
						Debug.Warning!(scope $"FT_Kerning({lhs.value.mIndex}, {rhs.value.mIndex}) responded with {response}");

					Kerning kerning = Kerning(vector.x / FT_FIXED_POINT_SCALE, vector.y / FT_FIXED_POINT_SCALE);
					glyph.mKernings.Add(rhs.value.mUnicode, kerning);
				}
			}
		}


		void BlitToAtlas (List<Sprite> sprites, Image destination)
		{
			for (uint32 n = 0; n < sprites.Count; n++)
			{
				Sprite sprite = sprites[n];
				Glyph glyph = this.mGlyphs[sprite.mUnicode];
	
				Image.Blit(sprite.mImage, destination, glyph.mPixelCoords[0], glyph.mPixelCoords[1]);
			}
		}

	
		public bool GetMetrics (char32 lhsUnicode, char32? rhsUnicode, float x, float y, out Font.Metrics glyphMetrics)
		{
			glyphMetrics = Font.Metrics();
			Kerning kerning = Kerning(0, 0);
	
			if (this.mGlyphs.TryGet(lhsUnicode, ?, var lhsGlyph) == false)
				return false;
	
			var foo = lhsGlyph;
	
			if (rhsUnicode.HasValue)
				foo.mKernings.TryGet(rhsUnicode.Value, ?, out kerning);
	
			glyphMetrics.mOffsetLeft = lhsGlyph.mOffestLeft;
			glyphMetrics.mOffsetTop = lhsGlyph.mOffsetTop;
	
			glyphMetrics.mPixelCoords = lhsGlyph.mPixelCoords;
			glyphMetrics.mTexCoords = lhsGlyph.mTexCoords;
	
			glyphMetrics.mAdvanceWidth = lhsGlyph.mAdvanceWidth;
			glyphMetrics.mAdvanceHeight = lhsGlyph.mAdvanceHeight;
			glyphMetrics.mKerning = kerning;
	
			return true;
		}
	

		public this ()
		{
			this.mGlyphs = new Dictionary<char32, Glyph>();
		}


		public ~this ()
		{
			for (var pair in this.mGlyphs)
				pair.value.Dispose();

			delete this.mGlyphs;
		}


		static void ParseCharacterSet (StringView[] characterSets, String buffer)
		{
			HashSet<char8> hashSet = scope HashSet<char8>();
			for (var setIdx = 0; setIdx < characterSets.Count; setIdx++)
			{
				var set = characterSets[setIdx];
				for (var n = 0; n < set.Length; n++)
				{
					hashSet.TryAdd(set[n], ?);
				}
			}

			buffer.Reserve(hashSet.Count);

			for (var char in hashSet)
				buffer.Append(char);
		}
	}
}