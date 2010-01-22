import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Config.Gnome
import XMonad.Util.EZConfig (additionalKeysP)
import XMonad.Util.Run (spawnPipe, hPutStrLn)

myStatusBar = "/home/jon/bin/dzen2 -xs 1 -e 'onstart=lower' -w 1170 -h 18 -ta l -fg '#ffffff' -bg '#000000'"

main = do
       din <- spawnPipe myStatusBar
       xmonad $ gnomeConfig
           { modMask = mod4Mask
           , terminal = "gnome-terminal"
           , workspaces = ["Web", "Term", "Emacs", "IM", "IRC", "Misc", "Ext"]
           , logHook = dynamicLogWithPP $ myPP din
           }
           `additionalKeysP` myKeys din

myPP h = defaultPP
             { ppCurrent = wrap "^fg(#000000)^bg(#09acda) " " ^fg()^bg()"
             , ppHidden = wrap " " " "
             , ppHiddenNoWindows = wrap " " " "
             , ppSep = ""
             , ppWsSep = ""
             , ppLayout = wrap " ^ro(8x8) " " "
             , ppTitle = \_ -> ""
             , ppOutput = hPutStrLn h
             }

myKeys conf = [ ("M-f", spawn "firefox")
              , ("M-t", spawn "gnome-terminal")
              , ("M-e", spawn "emacs")
              , ("M-[", spawn "mpc --no-status prev")
              , ("M-]", spawn "mpc --no-status next")
              , ("M-\\", spawn "mpc --no-status toggle")
              ]
