{-# LANGUAGE OverloadedStrings #-}

module DB where

import           Control.Monad
import           Data.ByteString.Char8 (readInteger)
import           Database.Redis
import           Internal

getViews :: IO Integer
getViews = do
  conn <- establishConnection
  resp <- runRedis conn $ get "views"
  disconnect conn
  return
    $ maybeToInt
    $ readFromMaybe
    $ join
    $ eitherToMaybe resp
    where
      maybeToInt Nothing       = 0
      maybeToInt (Just (x, _)) = x
      readFromMaybe (Just x) = readInteger x
      readFromMaybe _        = Nothing

incViews :: IO Integer
incViews = do
  conn <- establishConnection
  resp <- runRedis conn $ incr "views"
  disconnect conn
  return $ unwrap resp
    where
      unwrap (Right x) = x
      unwrap _         = -1

establishConnection :: IO Connection
establishConnection = checkedConnect defaultConnectInfo {connectHost = "redis"}
