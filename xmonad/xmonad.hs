import Control.Monad
import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Config.Gnome
import XMonad.Util.EZConfig (additionalKeysP)
import XMonad.Layout.NoBorders (smartBorders)
import XMonad.Util.Run (spawnPipe, hPutStrLn)
import XMonad.Hooks.SetWMName
import qualified XMonad.StackSet as W
import XMonad.Hooks.ManageHelpers
import XMonad.Util.Loggers
import XMonad.Config.Xfce

iconize :: String -> String
iconize s = "^i(/home/jon/pixmaps/" ++ s ++ ".xpm)"

iconizeVisible :: String -> String
iconizeVisible s = iconize (s ++ "-visible")

iconizeEmpty :: String -> String
iconizeEmpty s = iconize (s ++ "-empty")

logoWrap :: String -> String
-- logoWrap s = "" ++ (iconize "gentoo") ++ "^p(+4)" ++ s ++ "^p(+12)"
logoWrap s = "^p(+4)" ++ s ++ "^p(+12)"

main = do
  xmonad $ xfceConfig
           { modMask = mod4Mask
           , terminal = "urxvtc"
           , workspaces = ["web", "term", "emacs", "im", "irc", "vid", "doc", "misc"]
           , logHook = dynamicLogWithPP $ myPP
           , layoutHook = smartBorders $ layoutHook gnomeConfig
           , startupHook = startupHook gnomeConfig >> setWMName "LG3D"
           , manageHook = manageHook gnomeConfig <+> myManageHook
           }
           `additionalKeysP` myKeys

myPP = defaultPP
              { ppSep = ""
              , ppWsSep = ""
              , ppCurrent  = wrap (iconize "left-bracket") (iconize "right-bracket") . iconize
              , ppVisible  = wrap (iconizeVisible "left-bracket") (iconizeVisible "right-bracket") . iconize
              , ppHidden   = wrap "^p(+4)" "^p(+8)" . iconize
              , ppHiddenNoWindows = wrap "^p(+4)" "^p(+8)" . iconizeEmpty
              , ppLayout = logoWrap . (\x -> case x of
                               "Tall" -> (iconize "layout-tall")
                               "Mirror Tall" -> (iconize "layout-mirror-tall")
                               "Full" -> (iconize "layout-full")
                           )
              , ppTitle = \x -> ""
              , ppOrder = reverse                  
              , ppOutput = writeFile "/home/jon/.sysbar/pipe" . ("1 " ++) .  (++ "\n")
              }

myKeys = [ ("M-f", spawn "firefox")
         , ("M-x", spawn "urxvtc")
         , ("M-g", spawn "emacsclient -c")
         , ("M-d", spawn "pidgin")
         --, ("M-s", spawn "nautilus ~")
         , ("M-a", spawn "vlc")
         , ("M-z", spawn "evince")
         , ("<XF86MonBrightnessDown>", spawn "nvclock -S -5 &> /dev/null")
         , ("<XF86MonBrightnessUp>", spawn "nvclock -S +5 &> /dev/null")                                
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
               [ isFullscreen --> (doF W.focusDown <+> doFullFloat)
               ]
