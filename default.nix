{ pkgs, haskellPackages, mkCrazyShell }:

let
  name = "biohaskell-shell";

  libraries = p: with p; [
    dhall
    http-conduit
    lens
    lens-aeson
    megaparsec
    path
    procex
    vector
  ];

  base-libraries = p: [
    p.bytestring
    p.text
  ];

  header = ''
    \ESC[32m\STX #######  ####  #######  \ESC[m\STX##     ##    ###     ######  ##    ## ######## ##       ##     
    \ESC[32m\STX ##    ##  ##  ##     ## \ESC[m\STX##     ##   ## ##   ##    ## ##   ##  ##       ##       ##      
    \ESC[32m\STX ##    ##  ##  ##     ## \ESC[m\STX##     ##  ##   ##  ##       ##  ##   ##       ##       ##      
    \ESC[32m\STX #######   ##  ##     ## \ESC[m\STX######### ##     ##  ######  #####    ######   ##       ##      
    \ESC[32m\STX ##    ##  ##  ##     ## \ESC[m\STX##     ## #########       ## ##  ##   ##       ##       ##      
    \ESC[32m\STX ##    ##  ##  ##     ## \ESC[m\STX##     ## ##     ## ##    ## ##   ##  ##       ##       ##      
    \ESC[32m\STX #######  ####  #######  \ESC[m\STX##     ## ##     ##  ######  ##    ## ######## ######## ########
  '';

  notice = ''
    \ESC[1mNOTICE: This is an early version, most things will not work.\ESC[0m
  '';

  advice = ''
    The following commands are available:

  '';

  module-imports = ''
    import qualified Data.Aeson          as A
    import qualified Data.Aeson.Lens as L
    import qualified Data.Aeson.KeyMap   as A
    import qualified Control.Lens        as L
    import qualified Data.ByteString     as BS
    import qualified Data.List
    import           Data.Kind (Type)
    import           Data.Text (Text)
    import qualified Data.Text           as T
    import qualified Data.Text.Encoding  as T
    import qualified Dhall
    import qualified Dhall.Core
    import qualified Dhall.Pretty        as Dhall
    import qualified Data.Map as Map
    import qualified Network.HTTP.Simple as HTTP
    import qualified Procex.Prelude      as P ()
    import           Procex.Shell        (cd, initInteractive)
    import qualified Procex.Shell        as P ()
    import           System.Directory    (listDirectory, setCurrentDirectory)
    import           System.Environment  (getEnv, setEnv)
    import qualified Text.Megaparsec as M
    import qualified Text.Megaparsec.Char as M
    import qualified Text.Megaparsec.Char.Lexer as M
  '';

  ghciOptions = [
    "-XDataKinds"
    "-XExtendedDefaultRules"
    "-XGHC2021"
    "-XLambdaCase"
    "-XOverloadedStrings"
    "-XOverloadedLabels"
    "-Wall"
    "-Wno-type-defaults"
  ];

  promptFunction = ''
    :{
    promptFunction :: [String] -> Int -> IO String
    promptFunction _modules _line = do
      d <- getEnv "PWD"
      setCurrentDirectory d
      pure $ "\ESC[32m\STXBio\ESC[m\STXHaskell: "
    :}

  '';

  ghci-script = ''
    :{
        ls :: IO [FilePath]
        ls = listDirectory "."
    :}
  '';

in
mkCrazyShell {
  inherit name pkgs promptFunction ghciOptions haskellPackages module-imports libraries base-libraries header notice advice ghci-script;
}
