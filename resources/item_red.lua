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
        54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54,
        54, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 54,
        54, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 54,
        54, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 54,
        54, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 54,
        0, 0, 0, 0, 0, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        54, 54, 54, 54, 54, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 54, 54, 54, 54, 54,
        54, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 54,
        54, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 54,
        54, 0, 0, 0, 0, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 0, 0, 0, 0, 54,
        54, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 54,
        54, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 54,
        54, 54, 54, 54, 54, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 54, 54, 54, 54, 54,
        54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54, 54
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
          x = 160,
          y = 160,
          width = 480,
          height = 32,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "Solid",
          shape = "rectangle",
          x = 160,
          y = 352,
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
          y = 256,
          width = 160,
          height = 32,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "Solid",
          shape = "rectangle",
          x = 768,
          y = 288,
          width = 32,
          height = 160,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "Solid",
          shape = "rectangle",
          x = 640,
          y = 448,
          width = 160,
          height = 32,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "Solid",
          shape = "rectangle",
          x = 768,
          y = 32,
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
          y = 256,
          width = 160,
          height = 32,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "Solid",
          shape = "rectangle",
          x = 0,
          y = 288,
          width = 32,
          height = 160,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "Solid",
          shape = "rectangle",
          x = 0,
          y = 448,
          width = 160,
          height = 32,
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
          height = 128,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "WallDoor",
          shape = "rectangle",
          x = 0,
          y = 160,
          width = 32,
          height = 96,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "Player",
          shape = "rectangle",
          x = 64,
          y = 224,
          width = 32,
          height = 32,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "Solid",
          shape = "rectangle",
          x = 0,
          y = 0,
          width = 800,
          height = 32,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "Solid",
          shape = "rectangle",
          x = 0,
          y = 480,
          width = 800,
          height = 32,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "WallDoor",
          shape = "rectangle",
          x = 768,
          y = 160,
          width = 32,
          height = 96,
          visible = true,
          properties = {}
        }
      }
    }
  }
}
