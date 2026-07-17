[CmdletBinding()]
param(
    [ValidateRange(1, 20000)]
    [uint32] $DelayMs = 150,

    [ValidateRange(1, 20000)]
    [uint32] $RepeatMs = 15,

    [switch] $Disable,
    [switch] $Show
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

if (-not ('Dotfiles.KeyRepeat' -as [type])) {
    Add-Type -TypeDefinition @'
using System;
using System.ComponentModel;
using System.Runtime.InteropServices;

namespace Dotfiles
{
    public static class KeyRepeat
    {
        [StructLayout(LayoutKind.Sequential)]
        public struct FILTERKEYS
        {
            public uint cbSize;
            public uint dwFlags;
            public uint iWaitMSec;
            public uint iDelayMSec;
            public uint iRepeatMSec;
            public uint iBounceMSec;
        }

        private const uint SPI_GETFILTERKEYS = 0x0032;
        private const uint SPI_SETFILTERKEYS = 0x0033;
        private const uint FKF_FILTERKEYSON = 0x0001;
        private const uint FKF_AVAILABLE = 0x0002;
        private const uint SPIF_UPDATEINIFILE = 0x0001;
        private const uint SPIF_SENDCHANGE = 0x0002;

        [DllImport("user32.dll", SetLastError = true)]
        private static extern bool SystemParametersInfo(
            uint action,
            uint parameter,
            ref FILTERKEYS settings,
            uint flags
        );

        public static FILTERKEYS Get()
        {
            FILTERKEYS settings = new FILTERKEYS();
            settings.cbSize = (uint)Marshal.SizeOf(typeof(FILTERKEYS));

            if (!SystemParametersInfo(SPI_GETFILTERKEYS, settings.cbSize, ref settings, 0))
            {
                throw new Win32Exception(Marshal.GetLastWin32Error());
            }

            return settings;
        }

        public static void Set(uint delayMs, uint repeatMs)
        {
            FILTERKEYS settings = new FILTERKEYS();
            settings.cbSize = (uint)Marshal.SizeOf(typeof(FILTERKEYS));
            settings.dwFlags = FKF_FILTERKEYSON | FKF_AVAILABLE;
            settings.iWaitMSec = 1;
            settings.iDelayMSec = delayMs;
            settings.iRepeatMSec = repeatMs;
            settings.iBounceMSec = 0;

            if (!SystemParametersInfo(
                SPI_SETFILTERKEYS,
                0,
                ref settings,
                SPIF_UPDATEINIFILE | SPIF_SENDCHANGE))
            {
                throw new Win32Exception(Marshal.GetLastWin32Error());
            }
        }

        public static void Disable()
        {
            FILTERKEYS settings = Get();
            settings.dwFlags &= ~FKF_FILTERKEYSON;

            if (!SystemParametersInfo(
                SPI_SETFILTERKEYS,
                0,
                ref settings,
                SPIF_UPDATEINIFILE | SPIF_SENDCHANGE))
            {
                throw new Win32Exception(Marshal.GetLastWin32Error());
            }
        }
    }
}
'@
}

if (-not $Show) {
    if ($Disable) {
        [Dotfiles.KeyRepeat]::Disable()
    }
    else {
        [Dotfiles.KeyRepeat]::Set($DelayMs, $RepeatMs)
    }
}

$settings = [Dotfiles.KeyRepeat]::Get()

[PSCustomObject]@{
    Enabled  = (($settings.dwFlags -band 0x0001) -ne 0)
    DelayMs  = $settings.iDelayMSec
    RepeatMs = $settings.iRepeatMSec
    WaitMs   = $settings.iWaitMSec
    BounceMs = $settings.iBounceMSec
    Flags    = ('0x{0:X8}' -f $settings.dwFlags)
}
