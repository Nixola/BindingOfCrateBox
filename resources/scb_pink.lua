return {
  version = "1.1",
  luaversion = "5.1",
  orientation = "orthogonal",
  width = 25,
  height = 16,
  tilewidth = 32,
  tileheight = 32,
  properties = {},
  tilesets = {
    {
      name = "environment_32",
      firstgid = 1,
      tilewidth = 32,
      tileheight = 32,
      spacing = 0,
      margin = 0,
      image = "../../../ys/resources/tiles/environment_32.png",
      imagewidth = 512,
      imageheight = 512,
      properties = {},
      tiles = {}
    }
  },
  layers = {
    {
      type = "tilelayer",
      name = "Tile Layer 1",
      x = 0,
      y = 0,
      width = 25,
      height = 16,
      visible = true,
      opacity = 1,
      properties = {},
      encoding = "lua",
      data = {
        63, 63, 63, 63, 63, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 63, 63, 63, 63, 63,
        63, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 63,
        63, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 63,
        0, 0, 0, 0, 0, 63, 63, 63, 63, 63, 63, 63, 63, 63, 63, 63, 63, 63, 63, 63, 0, 0, 0, 0, 63,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 63,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 63,
        63, 63, 63, 63, 63, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 63, 63, 63, 63, 63,
        63, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 63,
        63, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 63,
        63, 0, 0, 0, 0, 63, 63, 63, 63, 63, 63, 63, 63, 63, 63, 63, 63, 63, 63, 63, 0, 0, 0, 0, 0,
        63, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        63, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        63, 63, 63, 63, 63, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 63, 63, 63, 63, 63,
        63, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 63,
        63, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 63,
        63, 0, 0, 0, 0, 63, 63, 63, 63, 63, 63, 63, 63, 63, 63, 63, 63, 63, 63, 63, 0, 0, 0, 0, 63
      }
    },
    {
      type = "objectgroup",
      name = "Object Layer 1",
      visible = true,
      opacity = 1,
      properties = {},
      objects = {
        {
          name = "",
          type = "Solid",
          shape = "rectangle",
          x = 768,
          y = 32,
          width = 32,
          height = 256,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "Solid",
          shape = "rectangle",
          x = 0,
          y = 192,
          width = 32,
          height = 320,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "Solid",
          shape = "rectangle",
          x = 0,
          y = 0,
          width = 160,
          height = 32,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "Solid",
          shape = "rectangle",
          x = 160,
          y = 480,
          width = 480,
          height = 32,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "Solid",
          shape = "rectangle",
          x = 640,
          y = 0,
          width = 160,
          height = 32,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "WallDoor",
          shape = "rectangle",
          x = 0,
          y = 96,
          width = 32,
          height = 96,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "WallDoor",
          shape = "rectangle",
          x = 768,
          y = 288,
          width = 32,
          height = 96,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "Spawner",
          shape = "rectangle",
          x = 384,
          y = 0,
          width = 32,
          height = 32,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "Player",
          shape = "rectangle",
          x = 64,
          y = 160,
          width = 32,
          height = 32,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "Automata",
          shape = "rectangle",
          x = 256,
          y = 480,
          width = 32,
          height = 32,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "Automata",
          shape = "rectangle",
          x = 224,
          y = 480,
          width = 32,
          height = 32,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "Automata",
          shape = "rectangle",
          x = 192,
          y = 480,
          width = 32,
          height = 32,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "Solid",
          shape = "rectangle",
          x = 768,
          y = 384,
          width = 32,
          height = 128,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "Solid",
          shape = "rectangle",
          x = 0,
          y = 32,
          width = 32,
          height = 64,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "Solid",
          shape = "rectangle",
          x = 640,
          y = 192,
          width = 128,
          height = 32,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "Solid",
          shape = "rectangle",
          x = 32,
          y = 192,
          width = 128,
          height = 32,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "Solid",
          shape = "rectangle",
          x = 640,
          y = 384,
          width = 128,
          height = 32,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "Solid",
          shape = "rectangle",
          x = 32,
          y = 384,
          width = 128,
          height = 32,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "Automata",
          shape = "rectangle",
          x = 288,
          y = 480,
          width = 32,
          height = 32,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "Automata",
          shape = "rectangle",
          x = 320,
          y = 480,
          width = 32,
          height = 32,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "Automata",
          shape = "rectangle",
          x = 352,
          y = 480,
          width = 32,
          height = 32,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "Automata",
          shape = "rectangle",
          x = 384,
          y = 480,
          width = 32,
          height = 32,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "Automata",
          shape = "rectangle",
          x = 416,
          y = 480,
          width = 32,
          height = 32,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "Automata",
          shape = "rectangle",
          x = 448,
          y = 480,
          width = 32,
          height = 32,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "Automata",
          shape = "rectangle",
          x = 480,
          y = 480,
          width = 32,
          height = 32,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "Automata",
          shape = "rectangle",
          x = 512,
          y = 480,
          width = 32,
          height = 32,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "Automata",
          shape = "rectangle",
          x = 544,
          y = 480,
          width = 32,
          height = 32,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "Automata",
          shape = "rectangle",
          x = 576,
          y = 480,
          width = 32,
          height = 32,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "Automata",
          shape = "rectangle",
          x = 576,
          y = 288,
          width = 32,
          height = 32,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "Automata",
          shape = "rectangle",
          x = 480,
          y = 288,
          width = 32,
          height = 32,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "Automata",
          shape = "rectangle",
          x = 448,
          y = 288,
          width = 32,
          height = 32,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "Automata",
          shape = "rectangle",
          x = 416,
          y = 288,
          width = 32,
          height = 32,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "Automata",
          shape = "rectangle",
          x = 224,
          y = 288,
          width = 32,
          height = 32,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "Automata",
          shape = "rectangle",
          x = 384,
          y = 288,
          width = 32,
          height = 32,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "Automata",
          shape = "rectangle",
          x = 352,
          y = 288,
          width = 32,
          height = 32,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "Solid",
          shape = "rectangle",
          x = 160,
          y = 288,
          width = 480,
          height = 32,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "Automata",
          shape = "rectangle",
          x = 320,
          y = 288,
          width = 32,
          height = 32,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "Automata",
          shape = "rectangle",
          x = 192,
          y = 288,
          width = 32,
          height = 32,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "Automata",
          shape = "rectangle",
          x = 512,
          y = 288,
          width = 32,
          height = 32,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "Automata",
          shape = "rectangle",
          x = 544,
          y = 288,
          width = 32,
          height = 32,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "Automata",
          shape = "rectangle",
          x = 288,
          y = 288,
          width = 32,
          height = 32,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "Automata",
          shape = "rectangle",
          x = 256,
          y = 288,
          width = 32,
          height = 32,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "Automata",
          shape = "rectangle",
          x = 576,
          y = 96,
          width = 32,
          height = 32,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "Automata",
          shape = "rectangle",
          x = 480,
          y = 96,
          width = 32,
          height = 32,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "Automata",
          shape = "rectangle",
          x = 448,
          y = 96,
          width = 32,
          height = 32,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "Automata",
          shape = "rectangle",
          x = 416,
          y = 96,
          width = 32,
          height = 32,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "Automata",
          shape = "rectangle",
          x = 224,
          y = 96,
          width = 32,
          height = 32,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "Automata",
          shape = "rectangle",
          x = 384,
          y = 96,
          width = 32,
          height = 32,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "Automata",
          shape = "rectangle",
          x = 352,
          y = 96,
          width = 32,
          height = 32,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "Solid",
          shape = "rectangle",
          x = 160,
          y = 96,
          width = 480,
          height = 32,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "Automata",
          shape = "rectangle",
          x = 320,
          y = 96,
          width = 32,
          height = 32,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "Automata",
          shape = "rectangle",
          x = 192,
          y = 96,
          width = 32,
          height = 32,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "Automata",
          shape = "rectangle",
          x = 512,
          y = 96,
          width = 32,
          height = 32,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "Automata",
          shape = "rectangle",
          x = 544,
          y = 96,
          width = 32,
          height = 32,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "Automata",
          shape = "rectangle",
          x = 288,
          y = 96,
          width = 32,
          height = 32,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "Automata",
          shape = "rectangle",
          x = 256,
          y = 96,
          width = 32,
          height = 32,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "Automata",
          shape = "rectangle",
          x = 64,
          y = 192,
          width = 32,
          height = 32,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "Automata",
          shape = "rectangle",
          x = 96,
          y = 192,
          width = 32,
          height = 32,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "Automata",
          shape = "rectangle",
          x = 128,
          y = 192,
          width = 32,
          height = 32,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "Automata",
          shape = "rectangle",
          x = 64,
          y = 384,
          width = 32,
          height = 32,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "Automata",
          shape = "rectangle",
          x = 96,
          y = 384,
          width = 32,
          height = 32,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "Automata",
          shape = "rectangle",
          x = 128,
          y = 384,
          width = 32,
          height = 32,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "Automata",
          shape = "rectangle",
          x = 640,
          y = 384,
          width = 32,
          height = 32,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "Automata",
          shape = "rectangle",
          x = 672,
          y = 384,
          width = 32,
          height = 32,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "Automata",
          shape = "rectangle",
          x = 704,
          y = 384,
          width = 32,
          height = 32,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "Automata",
          shape = "rectangle",
          x = 640,
          y = 192,
          width = 32,
          height = 32,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "Automata",
          shape = "rectangle",
          x = 672,
          y = 192,
          width = 32,
          height = 32,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "Automata",
          shape = "rectangle",
          x = 704,
          y = 192,
          width = 32,
          height = 32,
          visible = true,
          properties = {}
        }
      }
    }
  }
}
