namespace FreeType.UsageExample;


using System;
using System.Collections;
using System.Diagnostics;

using FreeType;


extension FreeType
{
	extension FontAtlas
	{
		struct Sprite : IDisposable
		{
			public char32 mUnicode;
			public Image mImage;


			public this (char32 unicode, int width, int height, int countChannels)
			{
				this.mUnicode = unicode;
				this.mImage = new FontAtlas.Image(width, height, countChannels);
			}


			public void Dispose () mut
			{
				delete this.mImage;
				this.mImage = null;
			}
		}
	}
}