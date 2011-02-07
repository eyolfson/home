import Control.Monad
import XMonad

import XMonad.Config.Gnome
import XMonad.Util.EZConfig (additionalKeysP)
import XMonad.Layout.NoBorders (smartBorders)
import XMonad.Util.Run (spawnPipe, hPutStrLn)
import XMonad.Hooks.SetWMName
import qualified XMonad.StackSet as S
import XMonad.Hooks.ManageHelpers
import XMonad.Util.Loggers
import XMonad.Config.Xfce
import List (elemIndex, intersperse)

import Data.Maybe (isJust, catMaybes)
import XMonad.Util.WorkspaceCompare (WorkspaceSort, getSortByIndex)
import XMonad.Hooks.DynamicLog (wrap)
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
--           , logHook = dynamicLogWithPP $ myPP
           , logHook = dynamicLogWithPPS $ myPPS
           , layoutHook = smartBorders $ layoutHook gnomeConfig
           , startupHook = startupHook gnomeConfig >> setWMName "LG3D"
           , manageHook = manageHook gnomeConfig <+> myManageHook
           }
           `additionalKeysP` myKeys

-- myPP = defaultPP
--               { ppSep = ""
--               , ppWsSep = ""
--               , ppCurrent  = wrap (iconize "left-bracket") (iconize "right-bracket") . iconize
--               , ppVisible  = wrap (iconizeVisible "left-bracket") (iconizeVisible "right-bracket") . iconize
--               , ppHidden   = wrap "^p(+4)" "^p(+8)" . iconize
--               , ppHiddenNoWindows = wrap "^p(+4)" "^p(+8)" . iconizeEmpty
--               , ppLayout = logoWrap . (\x -> case x of
--                                "Tall" -> (iconize "layout-tall")
--                                "Mirror Tall" -> (iconize "layout-mirror-tall")
--                                "Full" -> (iconize "layout-full")
--                            )
--               , ppTitle = \x -> ""
--               , ppOrder = reverse                  
--               , ppOutput = writeFile "/home/jon/.sysbar/pipe" . ("1 " ++) . (++ "\n")
--               }

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



-- myPP = defaultPP
--               { ppSep = ""
--               , ppWsSep = ""
--               , ppCurrent  = wrap (iconize "left-bracket") (iconize "right-bracket") . iconize
--               , ppVisible  = wrap (iconizeVisible "left-bracket") (iconizeVisible "right-bracket") . iconize
--               , ppHidden   = wrap "^p(+4)" "^p(+8)" . iconize
--               , ppHiddenNoWindows = wrap "^p(+4)" "^p(+8)" . iconizeEmpty
--               , ppLayout = logoWrap . (\x -> case x of
--                                "Tall" -> (iconize "layout-tall")
--                                "Mirror Tall" -> (iconize "layout-mirror-tall")
--                                "Full" -> (iconize "layout-full")
--                            )
--               , ppTitle = \x -> ""
--               , ppOrder = reverse                  
--               , ppOutput = writeFile "/home/jon/.sysbar/pipe" . ("1 " ++) . (++ "\n")
--               }

displayNumber :: Maybe ScreenId -> String
displayNumber m = case m of Nothing -> "^p(+4)"
                            Just n -> iconize ("screen-" ++ show ((\(S x) -> x) n + 1))

myPPS :: PPS
myPPS = PPS { ppCurrent         = \x -> wrap (iconize "left-bracket") (iconize "right-bracket" ++ displayNumber x) . iconize
            , ppVisible         = \x -> wrap "^p(+4)" ("^p(+4)" ++displayNumber x) . iconize
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


data PPS = PPS { ppCurrent :: Maybe ScreenId -> WorkspaceId -> String
               , ppVisible :: Maybe ScreenId -> WorkspaceId -> String
               , ppHidden  :: WorkspaceId -> String
               , ppHiddenNoWindows :: WorkspaceId -> String
               , ppUrgent :: WorkspaceId -> String
               , ppSep :: String
               , ppWsSep :: String
               , ppTitle :: String -> String
               , ppLayout :: String -> String
               , ppOrder :: [String] -> [String]
               , ppSort :: X ([WindowSpace] -> [WindowSpace])
               , ppExtras :: [X (Maybe String)]
               , ppOutput :: String -> IO ()
               }

-- The following are from XMonad.Hooks.DynamicLog
dynamicLogWithPPS :: PPS -> X ()
dynamicLogWithPPS pp = dynamicLogString pp >>= io . ppOutput pp

dynamicLogString :: PPS -> X String
dynamicLogString pp = do

    winset <- gets windowset
    urgents <- readUrgents
    sort' <- ppSort pp

    -- layout description
    let ld = description . S.layout . S.workspace . S.current $ winset

    -- workspace list
    let ws = pprWindowSet sort' urgents pp winset

    -- window title
    wt <- maybe (return "") (fmap show . getName) . S.peek $ winset

    -- run extra loggers, ignoring any that generate errors.
    extras <- sequence $ map (flip catchX (return Nothing)) $ ppExtras pp

    return $ encodeOutput . sepBy (ppSep pp) . ppOrder pp $
                        [ ws
                        , ppLayout pp ld
                        , ppTitle  pp wt
                        ]
                        ++ catMaybes extras

pprWindowSet :: WorkspaceSort -> [Window] -> PPS -> WindowSet -> String
pprWindowSet sort' urgents pp s = sepBy (ppWsSep pp) . map fmt . sort' $
            map S.workspace (S.current s : S.visible s) ++ S.hidden s
   where this     = S.currentTag s
         visibles = map (S.tag . S.workspace) (S.visible s)

         fmt w = printer pp (S.tag w)
          where printer | S.tag w == this                                               = \x -> ppCurrent x (lookupScreen s this)
                        | S.tag w `elem` visibles                                       = \x -> ppVisible x (lookupScreen s (S.tag w))
                        | any (\x -> maybe False (== S.tag w) (S.findTag x s)) urgents  = \ppC -> ppUrgent ppC . ppHidden ppC
                        | isJust (S.stack w)                                            = ppHidden
                        | otherwise                                                     = ppHiddenNoWindows

sepBy :: String -> [String] -> String
sepBy sep = concat . intersperse sep . filter (not . null)

lookupScreen :: WindowSet -> WorkspaceId -> Maybe ScreenId
lookupScreen s t 
    | null $ S.visible s                                   = Nothing
    | t == (S.tag . S.workspace . S.current) s             = Just $ (S.screen . S.current) s
    | otherwise  = ((map (S.screen) (S.visible s)) !!) `liftM`  i 
    where i = elemIndex t (map (S.tag . S.workspace) (S.visible s))
