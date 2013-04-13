import dsfml.system;
import dsfml.window;
import dsfml.graphics;
import std.stdio;
import std.algorithm;

void main()
{
	RenderWindow window = new RenderWindow(
				VideoMode(640,480),
				cast(immutable(dchar)[])"DSFML yay!",
				Window.Style.Close,
				ContextSettings(0,0,10,2,0));
	Event event;
	Clock clock = new Clock();
	float dt;

	Color gemCol = Color.Cyan - Color(0,0,0,100);
	Color col = Color(1,1,0,0);
	const float radStep = 30f;
	const float step = 200f;
	const float rotStep = 200f;
	const float dist = 30;
	const float minRadius = 2f;
	const float maxRadius = 200f;
	const float radius = 40f;
	const uint minPoints = 6;
	const uint maxPoints = 16;
	const uint pointCount = 11;
	Vector2f[string] dir = ["up":Vector2f(0,-1),"left":Vector2f(-1,0),"down":Vector2f(0,1),"right":Vector2f(1,0)];

	CircleShape shape = new CircleShape(radius, pointCount);
    shape.origin = Vector2f(radius,radius);
    shape.position = Vector2f(window.size.x/2f, window.size.y/2f);
    shape.outlineThickness = 16;
	shape.outlineColor = Color.Black;
	shape.fillColor = Color.Yellow;

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
			shape.pointCount = cast(uint)clamp(shape.pointCount - 1, minPoints, maxPoints);
			shape.radius = clamp(shape.radius - radStep * dt, minRadius, maxRadius);
			shape.origin = Vector2f(shape.radius, shape.radius);
			shape.fillColor = shape.fillColor - col * (dt * 700);
			shape.outlineColor = shape.outlineColor + col * (dt * 700);
		}
		if(Keyboard.isKeyPressed(Keyboard.Key.E))
		{
			shape.rotation = shape.rotation + rotStep * dt;
			shape.pointCount = cast(uint)clamp(shape.pointCount + 1, minPoints, maxPoints);
			shape.radius = clamp(shape.radius + radStep * dt, minRadius, maxRadius);
			shape.origin = Vector2f(shape.radius, shape.radius);
			shape.fillColor = shape.fillColor + col * (dt * 700);
			shape.outlineColor = shape.outlineColor - col * (dt * 700);
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
		window.display();
	}
}

static real clamp(real value, real minValue, real maxValue)
{
	return min(max(value, minValue), maxValue);
}