namespace FreeType.UsageExample;


using System;
using System.Collections;
using System.Diagnostics;

using FreeType;


extension FreeType
{
	extension FontAtlas
	{
		public struct Description
		{
			public FontFace mFontFace;
			public float mPointSize;

			public FT_Render_Mode mRenderMode = .FT_RENDER_MODE_NORMAL;

			public StringView[] mCharacterSets;
		}
	}
}