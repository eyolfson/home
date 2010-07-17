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

myStatusBar = "/home/jon/bin/dzen2 -ta l -xs 1 -h 24 -e 'onstart-lower'"

main = do
  --spawn "/usr/bin/tail -f /home/jon/.sysbar/pipe | /home/jon/bin/dmplex | /home/jon/bin/dzen2 -ta l -xs 1 -h 24"
  --statusBar <- spawnPipe myStatusBar
  xmonad $ xfceConfig
           { modMask = mod4Mask
           , terminal = "urxvt"
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
              , ppTitle = \x -> ""
              , ppOutput = writeFile "/home/jon/.sysbar/pipe" . ("1 " ++) .  (++ "\n")                  
              --, ppOutput   = writeFile "/home/jon/.sysbar/pipe" . ("1 " ++)
              --, ppOutput   = hPutStrLn statusBar
              }

myKeys = [ ("M-f", spawn "firefox")
         , ("M-x", spawn "urxvt")
         , ("M-g", spawn "emacsclient -c")
         , ("M-d", spawn "pidgin")
         --, ("M-s", spawn "nautilus ~")
         , ("M-a", spawn "vlc")
         , ("M-z", spawn "evince")
         , ("M-[", spawn "mpc --no-status prev")
         , ("M-]", spawn "mpc --no-status next")
         , ("M-\\", spawn "mpc --no-status toggle")
         --, ("M-p", spawn "xfrun4")
         --, ("M-Q", spawn "xfce4-session-logout")
         ]

myManageHook = composeAll
               [ isFullscreen --> (doF W.focusDown <+> doFullFloat)
               ]
