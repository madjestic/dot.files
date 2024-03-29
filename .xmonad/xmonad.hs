import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops         hiding (ewmh)
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Layout.Spacing
import XMonad.Util.EZConfig
import XMonad.Util.Run
import XMonad.StackSet
import XMonad.Layout.AvoidFloats
import XMonad.Actions.FloatSnap
import XMonad.Actions.FloatKeys
import XMonad.Actions.GridSelect
import XMonad.Hooks.Place
import XMonad.Layout.BinarySpacePartition
import XMonad.Layout.Fullscreen
import XMonad.Layout.Renamed
import XMonad.Layout.Circle
import XMonad.Layout.Hidden
import qualified XMonad.StackSet as W
import XMonad.Hooks.SetWMName

myLayout =
  renamed [CutWordsLeft 1]
  $ avoidStruts
  $ spacing 5
  $   bsp
  ||| circle 
  ||| full
  where       
    bsp    = renamed [Replace "BSP"]    $ hiddenWindows emptyBSP
    circle = renamed [Replace "Circle"] $ hiddenWindows Circle
    full   = renamed [Replace "Full"]   $ hiddenWindows Full

ewmh :: XConfig a -> XConfig a
ewmh c = c { startupHook     = startupHook c     <+> setWMName "LG3D"
           , logHook         = logHook c
           }        

main :: IO ()         
main = do
     xmproc <- spawnPipe "/usr/bin/xmobar ~/.xmobarrc"
     xmonad
       $ docks
       $ ewmh def
                 { manageHook = manageDocks <+> (isFullscreen --> doFullFloat) <+> manageHook def
                 , layoutHook = myLayout
                 , logHook    = dynamicLogWithPP xmobarPP
                                    { ppOutput = hPutStrLn xmproc
                                    , ppTitle = xmobarColor "SpringGreen" "" . shorten 80
                                    }
                 , terminal   = "urxvt"
                 , modMask    = mod4Mask
                 , focusedBorderColor   = "#444444"
                 , normalBorderColor    = "SeaGreen"
                 , borderWidth          = 1
                 }
             `additionalKeys`
                 [ ((mod4Mask                         , xK_Tab),     windows focusUp   >> windows shiftMaster)
                 , ((mod4Mask .|. shiftMask           , xK_Tab),     windows focusDown )
                 , ((mod4Mask .|. mod1Mask              , xK_k),     withFocused $ snapGrow   U Nothing)
                 , ((mod4Mask .|. mod1Mask .|. shiftMask, xK_j),     withFocused $ snapShrink U Nothing)
                 , ((mod4Mask .|. mod1Mask              , xK_j),     withFocused $ snapGrow   D Nothing)
                 , ((mod4Mask .|. mod1Mask .|. shiftMask, xK_k),     withFocused $ snapShrink D Nothing)
                 , ((mod4Mask .|. mod1Mask              , xK_h),     withFocused $ snapGrow   L Nothing)
                 , ((mod4Mask .|. mod1Mask .|. shiftMask, xK_l),     withFocused $ snapShrink L Nothing)
                 , ((mod4Mask .|. mod1Mask              , xK_l),     withFocused $ snapGrow   R Nothing)
                 , ((mod4Mask .|. mod1Mask .|. shiftMask, xK_h),     withFocused $ snapShrink R Nothing)
                 , ((mod4Mask .|. controlMask           , xK_Left),  withFocused $ snapMove   L Nothing)
                 , ((mod4Mask .|. controlMask           , xK_Right), withFocused $ snapMove   R Nothing)
                 , ((mod4Mask .|. controlMask           , xK_Up),    withFocused $ snapMove   U Nothing)
                 , ((mod4Mask .|. controlMask           , xK_Down),  withFocused $ snapMove   D Nothing)
                 , ((mod4Mask,               xK_Return), windows W.swapMaster)
                 , ((mod4Mask .|. shiftMask, xK_j     ), windows W.swapDown  )
                 , ((mod4Mask .|. shiftMask, xK_k     ), windows W.swapUp    )
                 , ((mod4Mask, xK_g), goToSelected def)
                 , ((mod4Mask, xK_backslash), withFocused hideWindow)
                 , ((mod4Mask .|. shiftMask, xK_backslash), popOldestHiddenWindow)                 
                 ]
             `additionalKeysP`
                 [ ("<XF86AudioMute>"        , spawn "amixer set Master toggle")
                 , ("<XF86AudioLowerVolume>" , spawn "amixer set Master 5%-")
                 , ("<XF86AudioRaiseVolume>" , spawn "amixer set Master 5%+")
                 , ("<XF86MonBrightnessDown>", spawn "/home/madjestic/bin/brightnessdown")
                 , ("<XF86MonBrightnessUp>"  , spawn "/home/madjestic/bin/brightnessup")
                 , ("<XF86AudioPlay>"        , spawn "playerctl play-pause")
                 , ("<XF86AudioNext>"        , spawn "playerctl next")
                 , ("<XF86AudioPrev>"        , spawn "playerctl previous")
                 , ("M-C-c"                  , spawn "google-chrome-stable")
                 , ("M-C-f"                  , spawn "firefox-bin")
                 , ("M-S-C-e"                , spawn "emacs")
                 , ("M-C-e"                  , spawn "emacsclient -c")
                 , ("M-C-<Esc>"              , spawn "htop")
                 , ("M-C-l"                  , spawn "slock")
                 , ("M-C-h"                  , spawn "houdini")
                 , ("M-i"                    , spawn "xcalib -invert -alter")
                 , ("M-p"                    , spawn "/home/madjestic/bin/dmenu")
                 , ("M-M1-p"                    , spawn "/home/madjestic/bin/rofirun.sh")
                 --, ("M-C-p"                  , spawn "rofirun")
                 --, ("M-M1-p"                 , spawn "rofirun") -- like dmenu, but with Alt
                 --, ("M-<Print>"              , spawn "screen")
                 , ("M-<Print>"              , spawn "scrot -l style=solid,width=1,opacity=100 -s ~/Screenshots/%b%d::%H%M%S.png")
                 --alias myscrot='scrot ~/Screenshots/%b%d::%H%M%S.png'
                 , ("M-C-<Print>"            , spawn "scrot ~/Screenshots/%b%d::%H%M%S.png")
                 , ("M-s"           , sendMessage $ Swap)
                 , ("M-M1-s"        , sendMessage $ Rotate)
                 , ("M-r"           , sendMessage $ RotateL)
                 , ("M-S-r"         , sendMessage $ RotateR)
                 , ("M-a"           , sendMessage $ Balance)
                 , ("M-M1-a"        , sendMessage $ Equalize)
                 , ("M-<Left>"      , sendMessage $ ShrinkFrom R)
                 , ("M-<Right>"     , sendMessage $ ExpandTowards R)
                 , ("M-<Up>"        , sendMessage $ ShrinkFrom D)
                 , ("M-<Down>"      , sendMessage $ ExpandTowards D)
                 , ("M-M1-<Left>"   , sendMessage $ ExpandTowards L)
                 , ("M-M1-<Right>"  , sendMessage $ ShrinkFrom L)
                 , ("M-M1-<Up>"     , sendMessage $ ExpandTowards U)
                 , ("M-M1-<Down>"   , sendMessage $ ShrinkFrom U)
                 ]
