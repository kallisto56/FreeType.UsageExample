namespace FreeType.UsageExample;


using System;
using System.Collections;
using System.Diagnostics;

using FreeType;


extension FreeType
{
	extension FontAtlas
	{
		public struct Kerning
		{
			public int mX;
			public int mY;


			public this (int x, int y)
			{
				this.mX = x;
				this.mY = y;
			}
		}
	}
}