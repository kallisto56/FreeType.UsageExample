namespace FreeType.UsageExample;


using System;
using System.Collections;
using System.Diagnostics;

using SDL2;


class Background
{
	const public SDL.Color[?] cColors = SDL.Color[?] (
		SDL.Color(0, 18, 25, 255),
		SDL.Color(0, 95, 115, 255),
		SDL.Color(10, 147, 150, 255),
		SDL.Color(148, 210, 189, 255),
		SDL.Color(233, 216, 166, 255),
		SDL.Color(238, 155, 0, 255),
		SDL.Color(202, 103, 2, 255),
		SDL.Color(187, 62, 3, 255),
		SDL.Color(174, 32, 18, 255),
		SDL.Color(155, 34, 38, 255),
	);


	static public void Draw (SDLApp app)
	{
		SDL.GetWindowSize(app.mWindow, var width, var height);
		int32 rectWidth = int32(Math.Ceiling(float(width) / cColors.Count));

		for (int32 n = 0; n < cColors.Count; n++)
		{
			int32 x = n * rectWidth;

			SDL.Color c = cColors[n];
			SDL.Rect rectangle = SDL.Rect(x, 0, rectWidth, height);
			SDL.SetRenderDrawColor(app.mRenderer, c.r, c.g, c.b, c.a);
			SDL.RenderFillRect(app.mRenderer, &rectangle);
		}
	}
}