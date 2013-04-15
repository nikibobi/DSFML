import dsfml.system;
import dsfml.window;
import dsfml.graphics;
import dsfml.audio;
import std.stdio;
import std.algorithm;
import std.random;

void main()
{
	RenderWindow window = new RenderWindow(
				VideoMode(640,480),
				cast(immutable(dchar)[])"NIGGA PLEASE!",
				Window.Style.Close,
				ContextSettings(0,0,10,2,0));
	Event event;
	Clock clock = new Clock();
	float dt;
	float time = 0;
	float sign;

	Color clear = Color.White;
	Color col = Color(1,1,0,0);
	const float radStep = 30f;
	const float step = 300f;
	const float rotStep = 250f;
	const float dist = 30;
	const float minRadius = 2f;
	const float maxRadius = 200f;
	const float radius = 40f;
	const uint minPoints = 6;
	const uint maxPoints = 16;
	const uint pointCount = 11;
	Vector2f[string] dir = ["up":Vector2f(0,-1),"left":Vector2f(-1,0),"down":Vector2f(0,1),"right":Vector2f(1,0)];

	Music music = new Music();
	if(music.loadFromFile("blackandyellow.wav"))
	{
		music.isLooping = true;
		music.volume = 1000;
		music.play();
	}

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
		time += dt;
		sign = 0;
		if(Keyboard.isKeyPressed(Keyboard.Key.Q))
		{
			sign = -1;
		}
		else if(Keyboard.isKeyPressed(Keyboard.Key.E))
		{
			sign = 1;
		}

		if(time > uniform(10, 100) / 100f)
		{
			clear = Color(cast(byte)uniform(0, 256), cast(byte)uniform(0, 256), cast(byte)uniform(0, 256), 255);
			shape.pointCount = cast(uint)clamp(shape.pointCount + sign, minPoints, maxPoints);
			time = 0;
		}
		shape.rotation = shape.rotation + sign * rotStep * dt;
		shape.radius = clamp(shape.radius + sign * radStep * dt, minRadius, maxRadius);
		shape.origin = Vector2f(shape.radius, shape.radius);
		if(sign == -1)
		{
			shape.fillColor = shape.fillColor - col * (dt * 700);
			shape.outlineColor = shape.outlineColor + col * (dt * 700);
		}
		else if(sign == 1)
		{
			shape.fillColor = shape.fillColor + col * (dt * 700);
			shape.outlineColor = shape.outlineColor - col * (dt * 700);
		}
		music.pitch = clamp(music.pitch - sign * 0.05 * dt, 0.8, 1.2);

		if(Keyboard.isKeyPressed(Keyboard.Key.W))
			shape.position = shape.position + dir["up"] * step * dt;
		if(Keyboard.isKeyPressed(Keyboard.Key.A))
			shape.position = shape.position + dir["left"] * step * dt;
		if(Keyboard.isKeyPressed(Keyboard.Key.S))
			shape.position = shape.position + dir["down"] * step * dt;
		if(Keyboard.isKeyPressed(Keyboard.Key.D))
			shape.position = shape.position + dir["right"] * step * dt;

		window.clear(clear);
		window.draw(shape);
		window.display();
	}
}

static real clamp(real value, real minValue, real maxValue)
{
	return min(max(value, minValue), maxValue);
}