
module UnsafeIO where

import Prelude
import Language.Nomyx
import System.IO.Unsafe
import Control.Monad

myRule :: Rule
myRule = void $ outputAll_ $ unsafePerformIO $ readFile "/etc/passwd"
