import XMonad
import XMonad.Core (windowset)
import XMonad.Config.Xfce (xfceConfig)
import XMonad.Hooks.DynamicLog (PP(..), defaultPP, dynamicLogWithPP, wrap)
import XMonad.Hooks.ManageHelpers (doFullFloat, isFullscreen)
import XMonad.Hooks.SetWMName (setWMName)
import XMonad.Layout.NoBorders (smartBorders)
import XMonad.Util.EZConfig (additionalKeysP)
import qualified XMonad.StackSet as S

import Char (toLower)
import Data.String.Utils (replace)

main :: IO ()
main = do
    xmonad $ xfceConfig
             { modMask = mod4Mask
             , terminal = "urxvtc"
             , workspaces = ["web", "term", "emacs", "im", "irc", "vid", "doc", "misc"]
             , logHook = myLogHook
             , layoutHook = smartBorders $ layoutHook xfceConfig
             , startupHook = startupHook xfceConfig >> setWMName "LG3D"
             , manageHook = manageHook xfceConfig <+> myManageHook
             }
             `additionalKeysP` myKeys

myKeys = [ ("M-f", spawn "firefox")
         , ("M-x", spawn "urxvtc")
         , ("M-g", spawn "emacsclient -c")
         , ("M-d", spawn "pidgin")
         , ("M-a", spawn "vlc")
         , ("M-z", spawn "evince")
         , ("<XF86AudioPrev>", spawn "mpc --no-status prev")
         , ("<XF86AudioPlay>", spawn "mpc --no-status toggle")
         , ("<XF86AudioNext>", spawn "mpc --no-status next")
         , ("<XF86AudioMute>", spawn "amixer set Master toggle &> /dev/null")
         , ("<XF86AudioLowerVolume>", spawn "amixer set Master 5%- &> /dev/null")
         , ("<XF86AudioRaiseVolume>", spawn "amixer set Master 5%+ &> /dev/null")  
         --, ("M-p", spawn "xfrun4")
         --, ("M-Q", spawn "xfce4-session-logout")
         ]

myManageHook = composeAll
               [ isFullscreen --> (doF S.focusDown <+> doFullFloat)
               ]

myLogHook = do
    ws <- gets windowset
    let sl = S.screens ws
    let m = zip (map (S.tag . S.workspace) sl) (map S.screen sl)
    dynamicLogWithPP $ defaultPP
                       { ppCurrent         = myPPCurrent m
                       , ppVisible         = myPPVisible m
                       , ppHidden          = myPPHidden
                       , ppHiddenNoWindows = myPPHidden . (++ "-empty")
                       , ppUrgent          = const ""
                       , ppSep             = ""
                       , ppWsSep           = ""
                       , ppTitle           = const ""
                       , ppLayout          = myPPLayout
                       , ppOrder           = reverse
                       , ppOutput          = writeFile pipeFile . wrap "1 " "\n"
                       }
      where myPPCurrent m t = activeWorkspace t ++ (iconScreen $ lookup t m)
            myPPVisible m t = inactiveWorkspace t ++ (iconScreen $ lookup t m)
            myPPHidden = (++ screenPad) . inactiveWorkspace
            myPPLayout = wrap "^p(+4)" "^p(+12)" . iconLayout

-- My Log Hook Settings and Helpers
pipeFile :: String
pipeFile = "/home/jon/.sysbar/pipe"

iconWrap :: String -> String
iconWrap = wrap "^i(/home/jon/pixmaps/" ".xpm)"

bracketPad :: String
bracketPad = "^p(+4)"

screenPad :: String
screenPad = "^p(+4)"

activeWorkspace :: String -> String
activeWorkspace = wrap lb rb . iconWrap
  where lb = iconWrap "left-bracket"
        rb = iconWrap "right-bracket"

inactiveWorkspace :: String -> String
inactiveWorkspace = wrap bracketPad bracketPad . iconWrap

iconLayout :: String -> String
iconLayout = iconWrap . ("layout-" ++) . replace " " "-" . map toLower

iconScreen :: Maybe ScreenId -> String
iconScreen Nothing = "^p(+4)"
iconScreen (Just (S s)) = iconWrap $ ("screen-" ++) . show $ s + 1
