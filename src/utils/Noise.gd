class_name Noise


static func default() -> OpenSimplexNoise:
	var noise = OpenSimplexNoise.new()
	noise.seed = Random.i_range(-1000, 1000)
	return noise


static func get_noise(persistence, octaves, period, lacunarity) -> OpenSimplexNoise:
	var noise = OpenSimplexNoise.new()
	noise.seed = Random.i_range(-1000, 1000)
	noise.persistence = persistence
	noise.octaves = octaves
	noise.period = period
	noise.lacunarity = lacunarity
	return noise
