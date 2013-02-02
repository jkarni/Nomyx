
{-# LANGUAGE DeriveDataTypeable, TypeSynonymInstances, FlexibleInstances, TypeFamilies #-}

module Types where
import Language.Nomyx.Expression
import Data.Typeable
import Data.List
import Data.Function
import Language.Haskell.Interpreter.Server
import Text.Blaze.Html5 hiding (map, label)
import Text.Reform
import Happstack.Server
import Text.Reform.Happstack()


type PlayerPassword = String


data PlayerMulti = PlayerMulti   { mPlayerNumber :: PlayerNumber,
                                   mPlayerName :: PlayerName,
                                   mPassword :: PlayerPassword,
                                   mMail :: MailSettings,
                                   inGame :: Maybe GameName}
                                   deriving (Eq, Show, Read, Typeable)

--- | A structure to hold the active games and players
data Multi = Multi { games   :: [Game],
                     mPlayers :: [PlayerMulti],
                     logs ::  Log,
                     sh :: ServerHandle}
                     deriving (Typeable)

instance Show Multi where
   show Multi{games=gs, mPlayers=mps} = show (sort gs) ++ "\n" ++ show (sort mps)

defaultMulti :: ServerHandle -> FilePath -> Multi
defaultMulti sh fp = Multi [] [] (defaultLog fp) sh

data Log = Log { logEvents :: [MultiEvent],
                 logFilePath :: FilePath } deriving (Eq)

defaultLog :: FilePath ->Log
defaultLog fp = Log [] fp

data MultiEvent =  MultiNewPlayer PlayerMulti
               | MultiNewGame String PlayerNumber
               | MultiJoinGame GameName PlayerNumber
               | MultiLeaveGame PlayerNumber
               | MultiSubscribeGame GameName PlayerNumber
               | MultiUnsubscribeGame GameName PlayerNumber
               | MultiSubmitRule String String String PlayerNumber
               | MultiInputChoiceResult EventNumber Int PlayerNumber
               | MultiInputStringResult String String PlayerNumber
               | MultiInputUpload PlayerNumber FilePath String deriving (Show, Read, Eq)


instance Ord PlayerMulti where
  (<=) = (<=) `on` mPlayerNumber

type NomyxForm a = Form (ServerPartT IO) [Input] String Html () a


data MailSettings = MailSettings { mailTo :: Maybe String,
                   mailNewInput :: Bool,
                   mailNewRule :: Bool,
                   mailNewOutput :: Bool,
                   mailConfirmed :: Bool } deriving (Eq, Show, Read)

defaultMailSettings :: MailSettings
defaultMailSettings = MailSettings Nothing False False False False

instance FormError String where
    type ErrorInputType String = [Input]
    commonFormError _ = "common error"


