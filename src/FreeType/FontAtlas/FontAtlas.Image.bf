namespace FreeType.UsageExample;


using System;
using System.Collections;
using System.Diagnostics;

using FreeType;


extension FreeType
{
	extension FontAtlas
	{
		public class Image
		{
			public uint8[] mData;

			public int mWidth;
			public int mHeight;
			public int mCountChannels;

			[Inline] public int SizeInBytes () => this.mWidth * this.mHeight * this.mCountChannels;
			[Inline] public int Pitch () => this.mWidth * this.mCountChannels;
			[Inline] public uint8* CArray () => this.mData.CArray();


			public this (int width, int height, int countChannels)
			{
				this.mWidth = width;
				this.mHeight = height;
				this.mCountChannels = countChannels;
				this.mData = new uint8[this.mWidth * this.mHeight * this.mCountChannels];
			}


			public ~this ()
			{
				delete this.mData;
			}


			static public void ConvertToARGB8888 (Image target)
			{
				uint8[] data = new uint8[target.mWidth * target.mHeight * 4];

				for (uint32 x = 0; x < target.mWidth; x++)
				{
					for (uint32 y = 0; y < target.mHeight; y++)
					{
						let lhsIdx = target.mHeight * y + x;
						let rhsIdx = lhsIdx * 4;

						data[rhsIdx + 0] = target.mData[lhsIdx];
						data[rhsIdx + 1] = 255;
						data[rhsIdx + 2] = 255;
						data[rhsIdx + 3] = 255;
					}
				}

				delete target.mData;
				target.mData = data;
				target.mCountChannels = 4;
			}


			static public void Blit (Image source, Image destination, int dstX, int dstY)
			{
				Debug.Assert(source.mCountChannels == destination.mCountChannels);
				Debug.Assert(dstX >= 0 && dstY >= 0);
				Debug.Assert(dstX + source.mWidth <= destination.mWidth);
				Debug.Assert(dstY + source.mHeight <= destination.mHeight);

				for (int y = 0; y < source.mHeight; y++)
				{
				    for (int x = 0; x < source.mWidth; x++)
				    {
				        int srcIdx = y * source.mWidth + x;
				        int dstIdx = ((y + dstY) * destination.mWidth + (x + dstX));

				        destination.mData[dstIdx] = source.mData[srcIdx];
				    }
				}
			}


			static public void Blit (FT_GlyphSlot source, Image destination)
			{
				Debug.Assert(destination.mCountChannels == 1);
				Debug.Assert(source.bitmap.width == destination.mWidth);
				Debug.Assert(source.bitmap.rows == destination.mHeight);

				Internal.MemCpy(destination.CArray(), source.bitmap.buffer, destination.SizeInBytes());
			}


			static public void Resize (Image target, int width, int height)
			{
				delete target.mData;
				target.mData = new uint8[width * height * target.mCountChannels];
				target.mWidth = width;
				target.mHeight = height;
			}
		}
	}
}