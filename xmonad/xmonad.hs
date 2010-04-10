import Control.OldException
import Control.Monad
import DBus
import DBus.Connection
import DBus.Message
import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Config.Gnome
import XMonad.Util.EZConfig (additionalKeysP)
import XMonad.Layout.NoBorders(smartBorders)

-- This retry is really awkward, but sometimes DBus won't let us get our
-- name unless we retry a couple times.
getWellKnownName :: Connection -> IO ()
getWellKnownName dbus = tryGetName `catchDyn` (\ (DBus.Error _ _) ->
                                                getWellKnownName dbus)
 where
  tryGetName = do
    namereq <- newMethodCall serviceDBus pathDBus interfaceDBus "RequestName"
    addArgs namereq [String "org.xmonad.Log", Word32 5]
    sendWithReplyAndBlock dbus namereq 0
    return ()


main :: IO ()
main = withConnection Session $ \ dbus -> do
  getWellKnownName dbus
  xmonad $ gnomeConfig
           { modMask = mod4Mask
           , terminal = "gnome-terminal"
           , workspaces = ["Web", "Term", "Emacs", "IM", "IRC", "Misc", "Pres"]
           , logHook = dynamicLogWithPP $ myPP dbus
           , layoutHook = smartBorders $ layoutHook gnomeConfig 
           }
           `additionalKeysP` myKeys

myPP dbus = defaultPP
             { ppCurrent  = pangoColor "#ad7fa8" . wrap "[" "]"
                            -- , ppHiddenNoWindows = wrap " " " "
                            -- , ppSep = ""
                            -- , ppWsSep = ""

             , ppTitle    = pangoColor "#729fcf" . shorten 50
             , ppVisible  = pangoColor "#663366" . wrap "(" ")"
             , ppHidden   = wrap " " " "
             , ppUrgent   = pangoColor "red"
             , ppOutput   = \ str -> do
               let str'  = "<span font=\"Terminus 9 Bold\">" ++ str ++ 
                           "</span>"
                   str'' = sanitize str'
               msg <- newSignal "/org/xmonad/Log" "org.xmonad.Log" 
                      "Update"
               addArgs msg [String str'']
               -- If the send fails, ignore it.
               send dbus msg 0 `catchDyn`
                 (\ (DBus.Error _name _msg) ->
                   return 0)
               return ()
             }

myKeys = [ ("M-f", spawn "firefox")
         , ("M-x", spawn "gnome-terminal")
         , ("M-g", spawn "emacs")
         , ("M-d", spawn "pidgin")
         , ("M-s", spawn "nautilus ~")
         , ("M-a", spawn "vlc")
         , ("M-z", spawn "evince")
         , ("M-[", spawn "mpc --no-status prev")
         , ("M-]", spawn "mpc --no-status next")
         , ("M-\\", spawn "mpc --no-status toggle")
         ]

pangoColor :: String -> String -> String
pangoColor fg = wrap left right
 where
  left  = "<span foreground=\"" ++ fg ++ "\">"
  right = "</span>"

sanitize :: String -> String
sanitize [] = []
sanitize (x:rest) | fromEnum x > 127 = "&#" ++ show (fromEnum x) ++ "; " ++
                                       sanitize rest
                  | otherwise        = x : sanitize rest
