namespace FreeType.UsageExample;


using System;
using System.Collections;
using System.Diagnostics;

using FreeType;


extension FreeType
{
	extension FontAtlas
	{
		struct Package : IDisposable
		{
			public List<Sprite> mSprites;
			public StringView mCharacterSet;
			public FontFace mFontFace;
			public FT_Render_Mode mRenderMode;


			public this (FontFace fontFace, FT_Render_Mode renderMode, StringView characterSet)
			{
				this.mSprites = new List<Sprite>();
				this.mCharacterSet = characterSet;
				this.mFontFace = fontFace;
				this.mRenderMode = renderMode;
			}


			public void Dispose ()
			{
				for (var n = 0; n < this.mSprites.Count; n++)
					this.mSprites[n].Dispose();

				delete this.mSprites;
			}
		}
	}
}