# Gruvbox colorscheme for ranger
# Based on the gruvbox theme for vim

from __future__ import (absolute_import, division, print_function)

from ranger.gui.colorscheme import ColorScheme
from ranger.gui.color import (
    black, blue, cyan, green, magenta, red, white, yellow, default,
    normal, bold, reverse, underline, BRIGHT,
    default_colors,
)

class Gruvbox(ColorScheme):
    progress_bar_color = 214  # Orange

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
                fg = 167  # Light red
                bg = 235  # Dark gray
            if context.border:
                fg = 239  # Medium gray
            if context.media:
                if context.image:
                    fg = 142  # Green
                else:
                    fg = 214  # Orange
            if context.container:
                fg = 109  # Blue-gray
            if context.directory:
                attr |= bold
                fg = 109  # Blue-gray
            elif context.executable and not \
                    any((context.media, context.container,
                        context.fifo, context.socket)):
                attr |= bold
                fg = 142  # Green
            if context.socket:
                fg = 175  # Pink
                attr |= bold
            if context.fifo or context.device:
                fg = 214  # Orange
                if context.device:
                    attr |= bold
            if context.link:
                fg = 132 if context.good else 167  # Cyan or light red
            if context.bad:
                fg = 167  # Light red
                bg = 235  # Dark gray
            if context.tag_marker and not context.selected:
                attr |= bold
                if fg in (red, magenta):
                    fg = white
                else:
                    fg = 167  # Light red
            if not context.selected and (context.cut or context.copied):
                fg = 223  # Light gray
                bg = 237  # Dark gray
            if context.main_column:
                if context.selected:
                    attr |= bold
                if context.marked:
                    attr |= bold
                    fg = 214  # Orange
            if context.badinfo:
                if attr & reverse:
                    bg = 167  # Light red
                else:
                    fg = 167  # Light red

        elif context.in_titlebar:
            attr |= bold
            if context.hostname:
                fg = 167 if context.bad else 142  # Light red or green
            elif context.directory:
                fg = 109  # Blue-gray
            elif context.tab:
                if context.good:
                    bg = 142  # Green
                    fg = 235  # Dark gray
            elif context.link:
                fg = 132  # Cyan

        elif context.in_statusbar:
            if context.permissions:
                if context.good:
                    fg = 142  # Green
                elif context.bad:
                    fg = 167  # Light red
            if context.marked:
                attr |= bold | reverse
                fg = 214  # Orange
            if context.message:
                if context.bad:
                    attr |= bold
                    fg = 167  # Light red
            if context.loaded:
                bg = self.progress_bar_color
                fg = 235  # Dark gray

        if context.text:
            if context.highlight:
                attr |= reverse

        if context.in_taskview:
            if context.title:
                fg = 109  # Blue-gray

            if context.selected:
                attr |= reverse

            if context.loaded:
                if context.selected:
                    fg = self.progress_bar_color
                    bg = 235  # Dark gray
                else:
                    bg = self.progress_bar_color
                    fg = 235  # Dark gray

        return fg, bg, attr