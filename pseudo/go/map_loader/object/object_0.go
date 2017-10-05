components {
  id: "script"
  component: "/pseudo/go/map_loader/object/object.script"
  position {
    x: 0.0
    y: 0.0
    z: 0.0
  }
  rotation {
    x: 0.0
    y: 0.0
    z: 0.0
    w: 1.0
  }
}
embedded_components {
  id: "sprite"
  type: "sprite"
  data: "tile_set: \"/assets/main.atlas\"\n"
  "default_animation: \"block\"\n"
  "material: \"/assets/materials/sprite/sprite.material\"\n"
  "blend_mode: BLEND_MODE_ALPHA\n"
  ""
  position {
    x: 0.0
    y: 0.0
    z: 0.0
  }
  rotation {
    x: 0.70710677
    y: 0.0
    z: 0.0
    w: 0.70710677
  }
}
