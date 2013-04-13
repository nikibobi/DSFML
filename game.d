import dsfml.system;
import dsfml.window;
import dsfml.graphics;
import std.stdio;

void main()
{
	RenderWindow window = new RenderWindow(
				VideoMode(640,480),
				"DSFML yay!",
				Window.Style.Close,
				ContextSettings(0,0,10,2,0));
	Event event;
	Clock clock = new Clock();
	float dt;

	Color gemCol = Color.Cyan - Color(0,0,0,100);
	Color col = Color(1,1,0,0);
	const float step = 200f;
	const float rotStep = 200f;
	const float dist = 30;
	Vector2f[string] dir = ["up":Vector2f(0,-1),"left":Vector2f(-1,0),"down":Vector2f(0,1),"right":Vector2f(1,0)];

	RectangleShape shape = new RectangleShape(Vector2f(64,64));
	shape.outlineThickness = 4;
	shape.outlineColor = Color.Black;
	shape.fillColor = Color.Yellow;
	shape.origin = Vector2f(shape.getGlobalBounds().width/2f, shape.getGlobalBounds().height/2f);
	shape.position = Vector2f(window.size.x/2f, window.size.y/2f);

	while(window.isOpen())
	{
		while(window.pollEvent(event))
		{
			if(event.type == Event.Closed)
			{
				window.close();
			}
		}

		dt = clock.restart().asSeconds();

		if(Keyboard.isKeyPressed(Keyboard.Key.Q))
		{
			shape.rotation = shape.rotation - rotStep * dt;
			shape.fillColor = shape.fillColor - col * (dt * 700);
		}
		if(Keyboard.isKeyPressed(Keyboard.Key.E))
		{
			shape.rotation = shape.rotation + rotStep * dt;
			shape.fillColor = shape.fillColor + col * (dt * 700);
		}

		if(Keyboard.isKeyPressed(Keyboard.Key.W))
		{
			shape.position = shape.position + dir["up"] * step * dt;
		}
		if(Keyboard.isKeyPressed(Keyboard.Key.A))
		{
			shape.position = shape.position + dir["left"] * step * dt;
		}
		if(Keyboard.isKeyPressed(Keyboard.Key.S))
		{
			shape.position = shape.position + dir["down"] * step * dt;
		}
		if(Keyboard.isKeyPressed(Keyboard.Key.D))
		{
			shape.position = shape.position + dir["right"] * step * dt;
		}

		window.clear(Color.White);
		window.draw(shape);
		window.draw([Vertex(Vector2f(-dist,-dist),gemCol),
					 Vertex(Vector2f(0,-dist),gemCol),
					 Vertex(Vector2f(dist,-dist),gemCol),
					 Vertex(Vector2f(-dist,0),gemCol),
					 Vertex(Vector2f(dist,0),gemCol),
					 Vertex(Vector2f(-dist,dist),gemCol),
					 Vertex(Vector2f(0,dist),gemCol),
					 Vertex(Vector2f(dist,dist),gemCol)
					 ],PrimitiveType.Quads, RenderStates(shape.getTransform()));
		window.display();
	}
}

unittest
{
	Color yellow = Color.Yellow;
	Color blue = Color.Blue;

	Color result = yellow + blue;
	yellow += blue;
	assert(result == Color.White);
	assert(result == yellow);
	assert((yellow - blue + Color(0,0,0,255)) == Color.Yellow);
	assert(yellow != Color.Black);

	Color c1 = Color(130,130,0,255);
	assert((c1 * 2) == Color.Yellow);
	writeln(Color(8,8,8,17) / 2);

	writeln(yellow.toString());
	assert((Color.Yellow + Color.Blue) == Color.White);
}