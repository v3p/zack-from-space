return {
  version = "1.1",
  luaversion = "5.1",
  tiledversion = "1.1.5",
  orientation = "orthogonal",
  renderorder = "left-down",
  width = 20,
  height = 9,
  tilewidth = 16,
  tileheight = 16,
  nextobjectid = 36,
  properties = {
    ["deadPlayer"] = false,
    ["hideHud"] = true
  },
  tilesets = {
    {
      name = "atlas",
      firstgid = 1,
      filename = "../../../WIP/maps/new/atlas.tsx",
      tilewidth = 16,
      tileheight = 16,
      spacing = 2,
      margin = 2,
      image = "../../img/atlas.png",
      imagewidth = 110,
      imageheight = 128,
      tileoffset = {
        x = 0,
        y = 0
      },
      grid = {
        orientation = "orthogonal",
        width = 16,
        height = 16
      },
      properties = {},
      terrains = {},
      tilecount = 42,
      tiles = {}
    }
  },
  layers = {
    {
      type = "tilelayer",
      name = "background",
      x = 0,
      y = 0,
      width = 20,
      height = 9,
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      encoding = "lua",
      data = {
        37, 37, 37, 37, 37, 37, 37, 37, 37, 37, 37, 37, 37, 37, 37, 37, 37, 37, 37, 37,
        37, 37, 37, 37, 37, 37, 37, 37, 37, 37, 37, 37, 37, 37, 37, 37, 37, 37, 37, 37,
        37, 37, 37, 37, 37, 37, 37, 37, 37, 37, 37, 37, 37, 37, 37, 37, 37, 37, 37, 37,
        37, 37, 37, 37, 37, 37, 37, 37, 37, 37, 37, 37, 37, 37, 37, 37, 37, 37, 37, 37,
        37, 37, 37, 37, 37, 37, 37, 37, 37, 37, 37, 37, 37, 37, 37, 37, 37, 37, 37, 37,
        37, 37, 37, 37, 37, 37, 37, 37, 37, 37, 37, 37, 37, 37, 37, 37, 37, 37, 37, 37,
        37, 37, 37, 37, 37, 37, 37, 37, 37, 37, 37, 37, 37, 37, 37, 37, 37, 37, 37, 37,
        37, 37, 37, 37, 37, 37, 37, 37, 37, 37, 37, 37, 37, 37, 37, 37, 37, 37, 37, 37,
        37, 37, 37, 37, 37, 37, 37, 37, 37, 37, 37, 37, 37, 37, 37, 37, 37, 37, 37, 37
      }
    },
    {
      type = "tilelayer",
      name = "tile",
      x = 0,
      y = 0,
      width = 20,
      height = 9,
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      encoding = "lua",
      data = {
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0,
        1, 35, 0, 0, 0, 0, 35, 0, 0, 0, 0, 35, 0, 0, 0, 0, 35, 1, 0, 0,
        1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0,
        1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0,
        1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0,
        1, 0, 0, 0, 0, 0, 0, 0, 0, 12, 0, 0, 12, 0, 0, 12, 0, 1, 0, 0,
        1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0,
        1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 0, 1, 1, 0, 1, 1, 0, 0,
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0
      }
    },
    {
      type = "tilelayer",
      name = "entity",
      x = 0,
      y = 0,
      width = 20,
      height = 9,
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      encoding = "lua",
      data = {
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
      }
    },
    {
      type = "objectgroup",
      name = "object",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      draworder = "topdown",
      properties = {},
      objects = {
        {
          id = 1,
          name = "",
          type = "spawnPoint",
          shape = "point",
          x = 42.663,
          y = 91.644,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 23,
          name = "",
          type = "teleportPortal",
          shape = "rectangle",
          x = 144,
          y = 112,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {
            ["action"] = "nextLevel",
            ["endLevel"] = true
          }
        },
        {
          id = 25,
          name = "",
          type = "",
          shape = "text",
          x = 19.0621,
          y = 31.753,
          width = 98.6121,
          height = 18.8438,
          rotation = 0,
          visible = true,
          text = "YOU WIN!",
          wrap = true,
          properties = {
            ["color"] = "green",
            ["font"] = "large"
          }
        },
        {
          id = 27,
          name = "score",
          type = "",
          shape = "text",
          x = 19.9553,
          y = 47.6983,
          width = 98.6121,
          height = 18.8438,
          rotation = 0,
          visible = true,
          text = "score",
          fontfamily = "Lucida Grande",
          pixelsize = 9,
          wrap = true,
          properties = {
            ["color"] = "green",
            ["font"] = "medium"
          }
        },
        {
          id = 28,
          name = "coins",
          type = "",
          shape = "text",
          x = 20.6805,
          y = 61.027,
          width = 98.6121,
          height = 10.6299,
          rotation = 0,
          visible = true,
          text = "coins",
          fontfamily = "Lucida Grande",
          pixelsize = 9,
          wrap = true,
          properties = {
            ["color"] = "gold",
            ["font"] = "small"
          }
        },
        {
          id = 29,
          name = "time",
          type = "",
          shape = "text",
          x = 21.0431,
          y = 66.9931,
          width = 98.6121,
          height = 9.3051,
          rotation = 0,
          visible = true,
          text = "time",
          fontfamily = "Lucida Grande",
          pixelsize = 9,
          wrap = true,
          properties = {
            ["color"] = "white",
            ["font"] = "small"
          }
        },
        {
          id = 30,
          name = "",
          type = "",
          shape = "text",
          x = 189.119,
          y = 59.5883,
          width = 31.3715,
          height = 18.0547,
          rotation = 0,
          visible = true,
          text = "repeat\nlevel",
          fontfamily = "Lucida Grande",
          pixelsize = 9,
          wrap = true,
          color = { 255, 0, 0 },
          properties = {
            ["color"] = "green",
            ["font"] = "small"
          }
        },
        {
          id = 32,
          name = "",
          type = "",
          shape = "text",
          x = 143.032,
          y = 60.9329,
          width = 53.8602,
          height = 18.8438,
          rotation = 0,
          visible = true,
          text = "next\nlevel",
          fontfamily = "Lucida Grande",
          pixelsize = 9,
          wrap = true,
          color = { 255, 0, 0 },
          properties = {
            ["color"] = "green",
            ["font"] = "small"
          }
        },
        {
          id = 33,
          name = "",
          type = "",
          shape = "text",
          x = 240.828,
          y = 65.3524,
          width = 53.8602,
          height = 18.8438,
          rotation = 0,
          visible = true,
          text = "menu",
          fontfamily = "Lucida Grande",
          pixelsize = 9,
          wrap = true,
          color = { 255, 0, 0 },
          properties = {
            ["color"] = "green",
            ["font"] = "small"
          }
        },
        {
          id = 34,
          name = "",
          type = "teleportPortal",
          shape = "rectangle",
          x = 192,
          y = 112,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {
            ["action"] = "repeatLevel",
            ["endLevel"] = true
          }
        },
        {
          id = 35,
          name = "",
          type = "teleportPortal",
          shape = "rectangle",
          x = 240,
          y = 112,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {
            ["action"] = "menu",
            ["endLevel"] = true
          }
        }
      }
    }
  }
}
