# Gruvbox colorscheme for ranger
# Based on the original Gruvbox theme by morhetz
# https://github.com/morhetz/gruvbox

from __future__ import (absolute_import, division, print_function)

from ranger.gui.colorscheme import ColorScheme
from ranger.gui.color import (
    black, blue, cyan, green, magenta, red, white, yellow, default,
    normal, bold, reverse, dim, BRIGHT,
    default_colors,
)


class Gruvbox(ColorScheme):
    progress_bar_color = 11

    def use(self, context):
        fg, bg, attr = default_colors

        if context.reset:
            return default_colors

        elif context.in_browser:
            if context.selected:
                attr = reverse
            else:
                attr = normal
            if context.empty or context.error:
                bg = 1
                fg = 15
            if context.border:
                fg = default
            if context.media:
                if context.image:
                    fg = 11  # yellow
                else:
                    fg = 13  # magenta
            if context.container:
                fg = 1  # red
            if context.directory:
                attr |= bold
                fg = 12  # blue
            elif context.executable and not \
                    any((context.media, context.container,
                         context.fifo, context.socket)):
                attr |= bold
                fg = 10  # green
            if context.socket:
                attr |= bold
                fg = 13  # magenta
            if context.fifo or context.device:
                fg = 11  # yellow
                if context.device:
                    attr |= bold
            if context.link:
                fg = 14  # cyan
                if context.bad:
                    bg = 1  # red
            if context.tag_marker and not context.selected:
                attr |= bold
                if fg in (1, 9):  # red
                    fg = white
                else:
                    fg = 1  # red
            if not context.selected and context.cut:
                fg = 8  # bright black
                bg = default
            if context.main_column:
                if context.selected:
                    attr |= bold
                if context.marked:
                    attr |= bold
                    bg = 11  # yellow
                    fg = 0   # black
            if context.badinfo:
                if attr & reverse:
                    bg = 1  # red
                else:
                    fg = 1  # red

        elif context.in_titlebar:
            attr |= bold
            if context.hostname:
                fg = 1  # red
            elif context.directory:
                fg = 12  # blue
            elif context.tab:
                if context.good:
                    bg = 10  # green
            elif context.link:
                fg = 14  # cyan

        elif context.in_statusbar:
            if context.permissions:
                if context.good:
                    fg = 14  # cyan
                elif context.bad:
                    fg = 1  # red
            if context.marked:
                attr |= bold | reverse
                fg = 11  # yellow
            if context.message:
                if context.bad:
                    attr |= bold
                    fg = 1  # red
                else:
                    fg = default
            if context.loaded:
                bg = self.progress_bar_color
            if context.vcsinfo:
                fg = 12  # blue
                attr &= ~bold
            if context.vcscommit:
                fg = 11  # yellow
                attr &= ~bold

        if context.text:
            if context.highlight:
                attr |= reverse

        if context.in_taskview:
            if context.title:
                fg = 12  # blue

            if context.selected:
                attr |= reverse

            if context.loaded:
                if context.selected:
                    fg = self.progress_bar_color
                else:
                    bg = self.progress_bar_color

        if context.vcsfile and not context.selected:
            attr &= ~bold
            # Some ranger versions expose 'vcsconflict' (singular) instead of 'vcsconflicts'.
            vcs_conflict = False
            if hasattr(context, 'vcsconflicts'):
                try:
                    vcs_conflict = bool(context.vcsconflicts)
                except Exception:
                    vcs_conflict = False
            elif hasattr(context, 'vcsconflict'):
                try:
                    vcs_conflict = bool(context.vcsconflict)
                except Exception:
                    vcs_conflict = False

            if vcs_conflict:
                fg = 1  # red
            elif getattr(context, 'vcschanged', False):
                fg = 11  # yellow
            elif getattr(context, 'vcsunknown', False):
                fg = 1  # red
            elif getattr(context, 'vcsstaged', False):
                fg = 10  # green
            elif getattr(context, 'vcssync', False):
                fg = 10  # green
            elif getattr(context, 'vcsignored', False):
                fg = default

        elif context.vcsremote and not context.selected:
            attr &= ~bold
            if context.vcssync:
                fg = 10  # green
            elif context.vcsbehind:
                fg = 1  # red
            elif context.vcsahead:
                fg = 12  # blue
            elif context.vcsdiverged:
                fg = 13  # magenta
            elif context.vcsunknown:
                fg = 1  # red

        return fg, bg, attr
