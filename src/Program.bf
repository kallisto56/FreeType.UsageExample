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
			mCharacterSets = scope StringView[] (CharacterSets.EN, CharacterSets.Numbers, CharacterSets.Symbols),
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

			if (font.GetMetrics(lhs, rhs, x, y, var metrics) == false)
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