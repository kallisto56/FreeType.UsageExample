namespace FreeType.UsageExample;


using System;
using System.Collections;
using System.Diagnostics;

using FreeType;
using SDL2;


extension FreeType
{
	public class Font : FontAtlas
	{
		public SDL.Texture* mHandle;
		public int mTextureWidth;
		public int mTextureHeight;


		public Response Initialize (SDL.Renderer* renderer, FontAtlas.Image image)
		{
			this.mTextureWidth = image.mWidth;
			this.mTextureHeight = image.mHeight;

			Image.ConvertToARGB8888(image);

			this.mHandle = SDL.CreateTexture(renderer, SDL.PIXELFORMAT_BGRA8888, .(SDL.TextureAccess.Static), .(image.mWidth), .(image.mHeight));
			if (this.mHandle == null)
				return new Error()..AppendF("Failed to create SDL_Texture: {}", StringView(SDL.GetError()));

			SDL.Rect rect = SDL.Rect(0, 0, .(image.mWidth), .(image.mHeight));
			int32 response = SDL.UpdateTexture(this.mHandle, &rect, image.CArray(), .(image.Pitch()));
			if (response == -1)
				return new Error()..AppendF("Failed at SDL.UpdateTexture: {}", StringView(SDL.GetError()));

			SDL.SetTextureBlendMode(this.mHandle, .Blend);

			return .Ok;
		}
	}
}