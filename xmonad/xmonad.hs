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

--added by jc
import XMonad.Hooks.SetWMName
import qualified XMonad.StackSet as W
import XMonad.Hooks.ManageHelpers

main = withConnection Session $ \ dbus -> do
  getWellKnownName dbus
  xmonad $ gnomeConfig
           { modMask = mod4Mask
           , terminal = "gnome-terminal"
           , workspaces = ["Web", "Term", "Emacs", "IM", "IRC", "Misc", "Pres"]
           , logHook = dynamicLogWithPP $ myPP dbus
           , layoutHook = smartBorders $ layoutHook gnomeConfig 

           -- added by jc
           , startupHook = startupHook gnomeConfig >> setWMName "LG3D"
           , manageHook = myManageHooks
           }
           `additionalKeysP` myKeys

myPP dbus = defaultPP
              { ppCurrent  = pangoColor "#ad7fa8" . wrap "" ""
              --, ppHiddenNoWindows = wrap "" ""
              --, ppSep = ""
              --, ppWsSep = ""
              --, ppTitle    = pangoColor "#729fcf" . shorten 50
              , ppTitle = \x -> ""
              , ppVisible  = pangoColor "#729fcf" . wrap "" ""
              , ppHidden   = wrap "" ""
              , ppUrgent   = pangoColor "#ef2929"
              , ppOutput   = \ str -> do
                  let str'  = "<span font=\"monospace\">" ++ str ++ "</span>"
                      str'' = sanitize str'
                  msg <- newSignal "/org/xmonad/Log" "org.xmonad.Log" "Update"
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

--added by jc
myManageHooks = composeAll
                [ isFullscreen --> doFullFloat
                ]


