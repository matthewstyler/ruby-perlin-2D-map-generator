# Ruby Perlin 2D Map Generator
A gem that procedurally generates seeded and customizable 2D map using perlin noise. Map can be rendered in console using ansi colors or returned as 2D array of hashes describing each tile and binome. Completely customizable, use the --help option for full usage details.


# Command line Usage
```bash
$ ./bin/ruby-perlin-2D-map-generator --help
```
```bash
Usage: ruby-perlin-2D-map-generator [OPTIONS] (DESCRIBE | RENDER)

Generate a replayable seeded procedurally generated 2 dimensional map. Rendered
in the console  using ASCII colours, or described as a hash containting each
tiles information.

Arguments:
  (DESCRIBE | RENDER)  command to run: render prints the map to standard
                       output using ansi colors, while describe prints each
                       tiles bionome information in the map.

Options:
      --elevation=float  Adjust each generated elevation by this percent (0 -
                         100) (default 0.0)
      --fhx=float        The frequency for height generation across the x-axis
                         (default 2.5)
      --fhy=float        The frequency for height generation across the y-axis
                         (default 2.5)
      --fmx=float        The frequency for moist generation across the x-axis
                         (default 2.5)
      --fmy=float        The frequency for moist generation across the y-axis
                         (default 2.5)
      --ftx=float        The frequency for temp generation across the x-axis
                         (default 2.5)
      --fty=float        The frequency for temp generation across the y-axis
                         (default 2.5)
      --gf=bool          Generate flora, significantly affects performance
      --height=int       The height of the generated map (default 128)
  -h, --help             Print usage
      --hs=int           The seed for a terrains height perlin generation
                         (default 10)
      --moisture=float   Adjust each generated moisture by this percent (0 -
                         100) (default 0.0)
      --ms=int           The seed for a terrains moist perlin generation
                         (default 300)
      --oh=int           Octaves for height generation (default 3)
      --om=int           Octaves for moist generation (default 3)
      --ot=int           Octaves for temp generation (default 3)
      --ph=float         Persistance for height generation (default 1.0)
      --pm=float         Persistance for moist generation (default 1.0)
      --pt=float         Persistance for temp generation (default 1.0)
      --temp=float       Adjust each generated temperature by this percent (0
                         - 100) (default 0.0)
      --ts=int           The seed for a terrains temperature perlin generation
                         (default 3000)
      --width=int        The width of the generated map (default 128)

Examples:
  Render with defaults
    $ ruby-perlin-2D-map-generator render

  Render with options
    $ ruby-perlin-2D-map-generator render --i=false --t=10 --ms=10
```
