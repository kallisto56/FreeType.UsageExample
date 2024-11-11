namespace FreeType.UsageExample;


using System;
using System.Collections;
using System.Diagnostics;

using FreeType;


extension FreeType
{
	extension FontAtlas
	{
		public struct Metrics
		{
			public int mAdvanceWidth;
			public int mAdvanceHeight;

			public int mOffsetLeft;
			public int mOffsetTop;

			public Kerning mKerning;

			public int[4] mPixelCoords;
			public float[4] mTexCoords;
		}
	}
}