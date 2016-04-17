module View.Object (render) where

import Model.Object exposing (Object, Category(..))
import WebGL as GL
-- import View.Common exposing (box, rectangle, Vertex)
import View.Mogee as Mogee
import View.Wall as Wall


render : GL.Texture -> (Float, Float) -> Object -> GL.Renderable
render texture offset {position, category, velocity, size} =
  let
    pos = (fst position - fst offset, snd position - snd offset)
  in
    case category of
      WallCategory ->
        Wall.render texture size pos
        -- rectangle size pos (0, 0, 0)
      MogeeCategory mogee ->
        Mogee.render texture pos mogee (if fst velocity < 0 then -1 else 1)