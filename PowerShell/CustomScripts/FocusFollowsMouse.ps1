Add-Type -TypeDefinition @'
    using System;
    using System.Runtime.InteropServices;
    using System.ComponentModel;

    public static class Spi {
        [System.FlagsAttribute]
        private enum Flags : uint {
            None            = 0x0,
            UpdateIniFile   = 0x1,
            SendChange      = 0x2,
        }

        [DllImport("user32.dll", SetLastError = true)]
        private static extern bool SystemParametersInfo(
            uint uiAction, uint uiParam, UIntPtr pvParam, Flags flags );

        [DllImport("user32.dll", SetLastError = true)]
        private static extern bool SystemParametersInfo(
            uint uiAction, uint uiParam, out bool pvParam, Flags flags );

        private static void check( bool ok ) {
            if( ! ok )
                throw new Win32Exception( Marshal.GetLastWin32Error() );
        }

        private static UIntPtr ToUIntPtr( this bool value ) {
            return new UIntPtr( value ? 1u : 0u );
        }

        public static bool GetFocusFollowsMouse() {
            bool enabled;
            check( SystemParametersInfo( 0x1000, 0, out enabled, Flags.None ) );
            return enabled;
        }

        public static void SetFocusFollowsMouse( bool enabled ) {
            // note: pvParam contains the boolean (cast to void*), not a pointer to it!
            check( SystemParametersInfo( 0x1001, 0, enabled.ToUIntPtr(), Flags.SendChange ) );
        }
    }
'@

# disable mouse-focus (default)
# [Spi]::SetFocusFollowsMouse( $false )

# enable mouse-focus
[Spi]::SetFocusFollowsMouse( $true )

# check if mouse-focus is enabled
[Spi]::GetFocusFollowsMouse()

