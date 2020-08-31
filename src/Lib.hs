{-# LANGUAGE OverloadedStrings #-}

module Lib
    ( runApp
    ) where

import           Prelude                       hiding (id)
import           Text.Blaze
import           Text.Blaze.Html.Renderer.Text (renderHtml)
import           Text.Blaze.Html5              (Html)
import qualified Text.Blaze.Html5              as H
import           Text.Blaze.Html5.Attributes

import           Web.Scotty

runApp :: IO ()
runApp = runServer

runServer :: IO ()
runServer = scotty 3000 $ do
  get "/" $
    html $ renderHtml page

  get "/meme.png" $
    file "assets/meme.png"

  get "/favicon.png" $
    file "assets/favicon.png"

  get "/style.css" $
    file "assets/style.css"

page :: Html
page = H.html $ do
  H.head $ do
    H.title "Meme"
    H.link ! rel "icon" ! type_ "image/png" ! href "favicon.png"
    H.link ! rel "stylesheet" ! href "style.css"

  H.body $
    H.div ! id "main" $
      H.img ! src "meme.png"
