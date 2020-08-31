module Internal where

eitherToMaybe :: Either l r -> Maybe r
eitherToMaybe (Right r) = Just r
eitherToMaybe _         = Nothing
