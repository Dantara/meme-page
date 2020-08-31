{-# LANGUAGE OverloadedStrings #-}

module Lib
    ( runApp
    ) where

import           Prelude                       hiding (id)

import           Text.Blaze
import           Text.Blaze.Html.Renderer.Text (renderHtml)
import           Text.Blaze.Html5              (Html, toHtml)
import qualified Text.Blaze.Html5              as H
import           Text.Blaze.Html5.Attributes

import           Web.Scotty

import           DB

import           Control.Monad.IO.Class

port :: Int
port = 8000

runApp :: IO ()
runApp = runServer

runServer :: IO ()
runServer = scotty port $ do
  get "/" $ do
    n <- liftIO incViews
    html $ renderHtml $ page n

  get "/meme.png" $
    file "assets/meme.png"

  get "/favicon.png" $
    file "assets/favicon.png"

  get "/style.css" $
    file "assets/style.css"

page :: Integer -> Html
page views = H.html $ do
  H.head $ do
    H.title "Meme"
    H.link ! rel "icon" ! type_ "image/png" ! href "favicon.png"
    H.link ! rel "stylesheet" ! href "style.css"

  H.body $
    H.div ! id "main" $ do
      H.h1 $ toHtml $ mconcat ["Views: ", show views]
      H.img ! src "meme.png"
