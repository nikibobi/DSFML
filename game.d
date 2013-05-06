import dsfml.system;
import dsfml.window;
import dsfml.graphics;
import dsfml.audio;
import std.stdio;
import std.math;
import std.algorithm;
import std.random;

class Nigga
{
	Color col = Color(1,1,0,0);
	const float radStep = 30f;
	const float step = 270f;
	const float rotStep = 350f;
	const float dist = 30;
	const float minRadius = 2f;
	const float maxRadius = 200f;
	const float radius = 40f;
	const uint minPoints = 6;
	const uint maxPoints = 16;
	const uint pointCount = 11;
	Vector2f[string] dir;

	private float polyInterval;
	private float sign;
	private Vector2f _position;

	public CircleShape shape;

	this()
	{
		dir = ["up":Vector2f(0,-1),"left":Vector2f(-1,0),"down":Vector2f(0,1),"right":Vector2f(1,0)];

		_position = Vector2f(uniform(0, 500) - 250, uniform(0, 500) - 250);
		shape = new CircleShape(radius, pointCount);
	    shape.origin = Vector2f(radius,radius);
	    shape.outlineThickness = 16;
		shape.outlineColor = Color.Black;
		shape.fillColor = Color.Yellow;
		polyInterval = 0;
		sign = 0;
	}

	@property
	{
		Vector2f position()
		{
			return _position;
		}
		void position(Vector2f value)
		{
			_position = value;
		}
	}

	void update(float dt)
	{
		polyInterval += dt;
		if(polyInterval > uniform(10, 1000) / 100f)
		{
			position = Vector2f(uniform(0, 500) - 250, uniform(0, 500) - 250);
			sign = uniform(0, 3) - 1;
			shape.pointCount = cast(uint)clamp(shape.pointCount + sign, minPoints, maxPoints);
			polyInterval = 0;
		}

		shape.radius = clamp(shape.radius + sign * radStep * dt, minRadius, maxRadius);
		shape.rotation = shape.rotation + sign * rotStep * dt * ((maxRadius - shape.radius) / (maxRadius - minRadius)) + sign * dt * 50f;
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
	}

	void draw(RenderTarget rt, RenderStates rs)
	{
		rt.draw(shape, rs);
	}
}

void main()
{
	//initialization
	uint style = Window.Style.Close;
	const(ContextSettings) settings = ContextSettings(0,0,10,2,0);
	RenderWindow window = new RenderWindow(
				VideoMode(640,480),
				"NIGGA PLEASE!",
				style,
				settings);
	Event event;
	Clock clock = new Clock();
	float dt = 0;
	float time = 0;
	float polyInterval = 0;
	float sign = 0;

	Color clear = Color.White;
	Color col = Color(1,1,0,0);
	const float radStep = 30f;
	const float step = 270f;
	const float rotStep = 350f;
	const float dist = 30;
	const float minRadius = 2f;
	const float maxRadius = 200f;
	const float radius = 40f;
	const uint minPoints = 6;
	const uint maxPoints = 16;
	const uint pointCount = 11;
	Vector2f[string] dir = ["up":Vector2f(0,-1),
							"left":Vector2f(-1,0),
							"down":Vector2f(0,1),
							"right":Vector2f(1,0)];
	Vector2f mousePos;

	//music
	Music music = new Music();
	if(music.loadFromFile("blackandyellow.ogg"))
	{
		music.isLooping = true;
		music.volume = 1000;
		music.play();
	}

	//other circles
	Nigga[] niggas = [new Nigga(),new Nigga(),new Nigga(),new Nigga()];

	//Circle main
	CircleShape shape = new CircleShape(radius, pointCount);
    shape.origin = Vector2f(radius,radius);
    shape.position = Vector2f(window.size.x/2f, window.size.y/2f);
    shape.outlineThickness = 16;
	shape.outlineColor = Color.Black;
	shape.fillColor = Color.Yellow;

	//enemy sprite
	Texture texture = new Texture();
	if(!texture.loadFromFile("enemy.png", IntRect(0, 0, 250, 250)))
	{
		writeln("texture could not be loaded");
	}
	Sprite sprite = new Sprite(texture);

	//shaders
	Shader vertShader = new Shader();
	Shader fragShader = new Shader();

	if(Shader.isAvailable())
	{
		if(!vertShader.loadFromFile("shader.vert", Shader.Type.Vertex))
		{
			writeln("vertShader not loaded corectly");
		}
		if(!fragShader.loadFromFile("shader.frag", Shader.Type.Fragment))
		{
			writeln("fragShader not loaded corectly");
		}
		else
		{
			fragShader.setParameter("texture", Shader.CurrentTexture);
		}
	}
	else
	{
		writeln("Shaders not supported");
	}

	while(window.isOpen())
	{
		while(window.pollEvent(event))
		{
			if(event.type == Event.Closed)
			{
				window.close();
			}
			if(event.type == Event.MouseMoved)
			{
				mousePos = Vector2f(event.mouseMove().x, event.mouseMove().y);
			}
		}

		dt = clock.restart().asSeconds();
		time += dt;
		polyInterval += dt;

		Vector2f v = Vector2f(cast(float)mousePos.x/window.size.x, cast(float)mousePos.y/window.size.y);
		vertShader.setParameter("wave_phase", time);
		vertShader.setParameter("wave_amplitude", v * 50);
		
		fragShader.setParameter("pixel_threshold", (v.x + v.y) / 30f);

		sign = 0;
		if(Keyboard.isKeyPressed(Keyboard.Key.Q))
		{
			sign = -1;
		}
		else if(Keyboard.isKeyPressed(Keyboard.Key.E))
		{
			sign = 1;
		}

		if(polyInterval > uniform(10, 100) / 100f)
		{
			clear = Color(cast(byte)uniform(0, 256), cast(byte)uniform(0, 256), cast(byte)uniform(0, 256), 255);
			shape.pointCount = cast(uint)clamp(shape.pointCount + sign, minPoints, maxPoints);
			polyInterval = 0;
		}

		shape.radius = clamp(shape.radius + sign * radStep * dt, minRadius, maxRadius);
		shape.rotation = shape.rotation + sign * rotStep * dt * ((maxRadius - shape.radius) / (maxRadius - minRadius)) + sign * dt * 50f;
		shape.origin = Vector2f(shape.radius, shape.radius);
		shape.outlineThickness = clamp(shape.outlineThickness - sign * radStep * dt, minRadius, maxRadius / 6);
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
			window.position = window.position + dir["up"] * step * dt;
		if(Keyboard.isKeyPressed(Keyboard.Key.A))
			window.position = window.position + dir["left"] * step * dt;
		if(Keyboard.isKeyPressed(Keyboard.Key.S))
			window.position = window.position + dir["down"] * step * dt;
		if(Keyboard.isKeyPressed(Keyboard.Key.D))
			window.position = window.position + dir["right"] * step * dt;

		foreach(nigga; niggas)
		{
			nigga.update(dt);
			nigga.shape.position = shape.position + nigga.position;
		}

		window.clear(clear);

		foreach(nigga; niggas)
		{
			nigga.draw(window, RenderStates.Default());
		}
		window.draw(shape, RenderStates(vertShader));
		window.draw(sprite, RenderStates(fragShader));
		window.display();
	}
}

static real clamp(real value, real minValue, real maxValue)
{
	return min(max(value, minValue), maxValue);
}