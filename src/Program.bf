namespace FreeType.UsageExample;


using System;
using System.Collections;
using System.Diagnostics;

using FreeType;
using SDL2;


class Program : SDLApp
{
	public StringView mFontFileName = @"C:\Windows\Fonts\Tahoma.ttf";
	public float mPointSize = 64;

	public FreeType.Font mFontSmall;
	public FreeType.Font mFontNormal;
	public FreeType.Font mFontLarge;
	public FreeType.Font mFontSDF;


	override public void Init ()
	{
		base.Init();
		SDL.SetWindowResizable(this.mWindow, true);
		SDL.SetWindowTitle(this.mWindow, "FreeType");

		if (LoadFonts() case .Err(Error error))
		{
			Debug.Report(error);
			Debug.Break();
		}
	}


	Response LoadFonts ()
	{
		this.mFontSmall = this.LoadFont(this.mFontFileName, 14, .FT_RENDER_MODE_LIGHT).Resolve!();
		this.mFontNormal = this.LoadFont(this.mFontFileName, this.mPointSize, .FT_RENDER_MODE_NORMAL).Resolve!();
		this.mFontLarge = this.LoadFont(this.mFontFileName, 96, .FT_RENDER_MODE_NORMAL).Resolve!();
		this.mFontSDF = this.LoadFont(this.mFontFileName, this.mPointSize, .FT_RENDER_MODE_SDF).Resolve!();

		return .Ok;
	}


	public Response<FreeType.Font> LoadFont (StringView fileName, float pointSize, FT_Render_Mode renderMode = .FT_RENDER_MODE_NORMAL)
	{
		FreeType.FontAtlas.Image image = scope FreeType.FontAtlas.Image(768, 768, 1);

		FreeType.FontFace fontFace = scope FreeType.FontFace();
		fontFace.Initialize(fileName, 0, pointSize).Resolve!();

		FreeType.Font font = new FreeType.Font();

		FreeType.FontAtlas.Description atlasDescription = FreeType.FontAtlas.Description()
		{
			mFontFace = fontFace,
			mPointSize = pointSize,
			mCharacterSets = scope StringView[] (CharacterSets.EN, CharacterSets.FR, CharacterSets.Numbers, CharacterSets.Symbols),
			mRenderMode = renderMode,
		};

		if (font.Initialize(atlasDescription, image) case .Err(Error error))
		{
			delete font;
			return new Error(error);
		}

		if (font.Initialize(this.mRenderer, image) case .Err(Error error))
		{
			delete font;
			return new Error(error);
		}

		return font;
	}


	public ~this ()
	{
		delete this.mFontLarge;
		delete this.mFontNormal;
		delete this.mFontSmall;
		delete this.mFontSDF;
	}


	override public void Draw ()
	{
		base.Draw();

		Background.Draw(this);

		SDL.GetWindowSize(this.mWindow, var width, var height);

		float tx = 32;
		float ty = this.mFontNormal.mLineHeight;
		this.DrawString("The quick brown fox jumps over the lazy dog.", tx, ty, this.mFontNormal); ty += this.mFontNormal.mLineHeight;
		this.DrawString("The swift SDF fox outlines every lazy glyph.", tx, ty, this.mFontSDF); ty += this.mFontSDF.mLineHeight;


		SDL.Rect rectangle = SDL.Rect(0, height - 60, width, 60);
		SDL.SetRenderDrawColor(this.mRenderer, 0, 0, 0, 200);
		SDL.RenderFillRect(this.mRenderer, &rectangle);
		this.DrawString("This project uses the FreeType library, which is licensed under the FreeType License.", tx, height - this.mFontSmall.mLineHeight, this.mFontSmall);

		this.DrawCharacter();
	}


	public void DrawCharacter ()
	{
		var x = 32;
		var y = 300;
		SDL.GetWindowSize(this.mWindow, var width, ?);

		var ax = 620; // x-coordinate for annotations

		var font = this.mFontLarge;
		var text = "TypogrÀphy";

		var ascentColor = SDL.Color(233, 216, 166, 255);
		var capHeightColor = SDL.Color(238, 155, 0, 255);
		var meanlineColor = SDL.Color(202, 103, 2, 255);
		var baselineColor = SDL.Color(187, 62, 3, 255);
		var descentColor = SDL.Color(174, 32, 18, 255);

		var baseline = int(y);
		var ascent = int(baseline - font.mAscent);
		var descent = int(baseline - font.mDescent);
		var xHeight = int(baseline - font.mMeanline);
		var capHeight = int(baseline - font.mCapHeight);

		// Black rect to tone down background
		DrawRect(0, int(y - font.mLineHeight), width, int(font.mLineHeight - font.mDescent * 2), SDL.Color(0, 0, 0, 200));

		// Origin point for DrawString
		{
			DrawRect(x-4, baseline-4, 9, 9, baselineColor);
			DrawRect(x, int(baseline-font.mLineHeight), 1, int(font.mLineHeight), baselineColor);
		}

		// Ascent
		DrawRect(0, ascent, width, 1, ascentColor);
		this.DrawString("Ascent", ax, ascent - 1, this.mFontSmall, ascentColor);

		// CapHeight
		DrawRect(0, capHeight, width, 1, capHeightColor);
		this.DrawString("CapHeight (height of the capital letters)", ax, capHeight - 1, this.mFontSmall, capHeightColor);

		// Meanline (also known as x-height
		DrawRect(0, xHeight, width, 1, meanlineColor);
		this.DrawString("Meanline (also known as x-height)", ax, xHeight - 1, this.mFontSmall, meanlineColor);

		// Baseline
		DrawRect(0, baseline-1, width, 3, baselineColor);
		this.DrawString("Baseline", ax, baseline - 2, this.mFontSmall, baselineColor);

		// Descent
		DrawRect(0, descent, width, 1, descentColor);
		this.DrawString("Descent", ax, descent - 1, this.mFontSmall, descentColor);

		// ...
		this.DrawString(text, x, y, font);
	}


	public void DrawRect (int x, int y, int width, int height, SDL.Color color = SDL.Color(255, 255, 255, 255))
	{
		SDL.Rect rectangle = SDL.Rect(int32(x), int32(y), int32(width), int32(height));
		SDL.SetRenderDrawColor(this.mRenderer, color.r, color.g, color.b, color.a);
		SDL.RenderFillRect(this.mRenderer, &rectangle);
	}


	public void DrawString (StringView textContent, float x, float y, FreeType.Font font, SDL.Color color = SDL.Color(255, 255, 255, 255))
	{
		SDL.SetTextureColorMod(font.mHandle, color.r, color.g, color.b);
		SDL.SetTextureAlphaMod(font.mHandle, color.a);

		var initialX = x;
		var x;
		var y;

		for (uint32 n = 0; n < textContent.Length; n++)
		{
			char32 lhs = textContent.GetChar32(n).c;
			char32? rhs = null;

			if (lhs == '\n')
			{
				y += font.mLineHeight;
				x = initialX;
				continue;
			}

			if (n + 1 < textContent.Length)
				rhs = textContent.GetChar32(n + 1).c;

			if (font.GetMetrics(lhs, rhs, var metrics) == false)
				continue;

			SDL.Rect srcRect = SDL.Rect(
				int32(metrics.mPixelCoords[0]),
				int32(metrics.mPixelCoords[1]),
				int32(metrics.mPixelCoords[2]),
				int32(metrics.mPixelCoords[3])
			);

			SDL.Rect dstRect = SDL.Rect(
				int32(x + metrics.mOffsetLeft),
				int32(y - metrics.mOffsetTop),
				srcRect.w,
				srcRect.h
			);

			SDL.RenderCopy(this.mRenderer, font.mHandle, &srcRect, &dstRect);

			x += metrics.mAdvanceWidth + metrics.mKerning.mX;
		}
	}


	static void Main ()
	{
		var library = scope FreeType.Library(bIsMainThreadInstance: true);
		if (library.Initialize() case .Err(Error error))
		{
			Debug.Report(error);
			Debug.Break();
		}

		scope Program()..PreInit()..Init()..Run();
	}
}