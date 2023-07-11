{- cabal:
build-depends: base ^>= 4.17.1.0
             , bytestring
             , base16-bytestring ^>= 1.0
             , containers
             , ed25519
             , hackage-security ^>= 0.6.2.3
-}
{- project:
with-compiler: ghc-9.4.5
-}
{-# LANGUAGE ImportQualifiedPost #-}
{-# LANGUAGE LambdaCase #-}
{-# LANGUAGE ScopedTypeVariables #-}

import Control.Monad
import Crypto.Sign.Ed25519 (unPublicKey)
import Data.ByteString.Base16 qualified as Base16
import Data.ByteString.Char8 qualified as BS
import Data.Foldable (for_)
import Data.Map qualified as Map
import Hackage.Security.Key.Env qualified as KeyEnv
import Hackage.Security.Server
import Hackage.Security.Util.Path (fromFilePath, makeAbsolute, toFilePath)
import Hackage.Security.Util.Pretty (pretty)
import Hackage.Security.Util.Some
import System.Environment (getArgs)
import System.Exit (exitFailure, exitSuccess)

main = do
  getArgs
    >>= traverse
      ( \fp -> do
          afp <- makeAbsolute (fromFilePath fp)
          readJSON_Keys_NoLayout KeyEnv.empty afp >>= \case
            Left e ->
              do
                putStrLn $ "Deserialisation error in " ++ fp
                putStrLn $ pretty e
                exitFailure
            Right (sr :: Signed Root) ->
              do
                putStrLn $ fp ++ " seems to work"
                for_ (Map.toList $ KeyEnv.keyEnvMap $ rootKeys $ signed sr) $ \(KeyId keyId, somePublicKey) ->
                  putStrLn $ "keyId: " ++ keyId ++ "\tpublic key: " ++ showSomePublicKey somePublicKey
      )

showSomePublicKey :: Some PublicKey -> [Char]
showSomePublicKey = BS.unpack . Base16.encode . exportSomePublicKey
  where
    exportSomePublicKey :: Some PublicKey -> BS.ByteString
    exportSomePublicKey (Some k) = exportPublicKey k

    exportPublicKey :: PublicKey a -> BS.ByteString
    exportPublicKey (PublicKeyEd25519 pub) = unPublicKey pub
