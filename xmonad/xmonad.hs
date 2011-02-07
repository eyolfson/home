import Control.Monad (liftM)
import Control.Monad.State.Class (gets)
import XMonad.Core (windowset)
import XMonad
import XMonad.Util.EZConfig (additionalKeysP)
import XMonad.Layout.NoBorders (smartBorders)
import XMonad.Util.Run (spawnPipe, hPutStrLn)
import XMonad.Hooks.SetWMName
import qualified XMonad.StackSet as S
import XMonad.Hooks.ManageHelpers
import XMonad.Util.Loggers
import XMonad.Config.Xfce (xfceConfig)
import List (elemIndex, intersperse)
import Data.Maybe (isJust, catMaybes)
import XMonad.Util.WorkspaceCompare (WorkspaceSort, getSortByIndex)
import XMonad.Hooks.DynamicLog --(wrap, dynamicLogWithPP, defaultPP)
import XMonad.Hooks.UrgencyHook (readUrgents)
import XMonad.Util.NamedWindows (getName)
import XMonad.Util.Font (encodeOutput)

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
           , logHook = myLogHook 
           -- , logHook = dynamicLogWithPPS $ myPPS
           , layoutHook = smartBorders $ layoutHook xfceConfig
           , startupHook = startupHook xfceConfig >> setWMName "LG3D"
           , manageHook = manageHook xfceConfig <+> myManageHook
           }
           `additionalKeysP` myKeys

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
               [ isFullscreen --> (doF S.focusDown <+> doFullFloat)
               ]

myLogHook = do ss <- gets windowset
               dynamicLogWithPP $ defaultPP
                   { ppCurrent = \x -> wrap (iconize "left-bracket") (iconize "right-bracket" ++ displayNumber (lookupScreen ss x)) $ iconize x
                   , ppVisible         = \x -> wrap "^p(+4)" ("^p(+4)" ++displayNumber (lookupScreen ss x)) $ iconize x
                   , ppHidden          = wrap "^p(+4)" "^p(+8)" . iconize
                   , ppHiddenNoWindows = wrap "^p(+4)" "^p(+8)" . iconizeEmpty
                   , ppUrgent          = const ""
                   , ppSep             = ""
                   , ppWsSep           = ""
                   , ppTitle           = const ""
                   , ppLayout          = logoWrap . (\x -> case x of
                                                        "Tall" -> (iconize "layout-tall")
                                                        "Mirror Tall" -> (iconize "layout-mirror-tall")
                                                        "Full" -> (iconize "layout-full")
                                                    )
                   , ppOrder           = reverse
                   , ppOutput          = writeFile "/home/jon/.sysbar/pipe" . ("1 " ++) . (++ "\n")
                   , ppSort            = getSortByIndex
                   , ppExtras          = []
                   }

displayNumber :: Maybe ScreenId -> String
displayNumber m = case m of Nothing -> "^p(+4)"
                            Just n -> iconize ("screen-" ++ show ((\(S x) -> x) n + 1))

lookupScreen :: WindowSet -> WorkspaceId -> Maybe ScreenId
lookupScreen s t 
    | null $ S.visible s                                   = Nothing
    | t == (S.tag . S.workspace . S.current) s             = Just $ (S.screen . S.current) s
    | otherwise  = ((map (S.screen) (S.visible s)) !!) `liftM`  i 
    where i = elemIndex t (map (S.tag . S.workspace) (S.visible s))
