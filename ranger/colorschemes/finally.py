from ranger.gui.colorscheme import ColorScheme
from ranger.gui.color import *

class Finally(ColorScheme):
    progress_bar_color = green

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
                fg = red
            if context.border:
                fg = black
            if context.image:
                fg = yellow
            if context.video:
                attr |= bold
                fg = yellow
            if context.audio:
                fg = magenta
            if context.document:
                fg = cyan
            if context.container:
                attr |= bold
                fg = red
            if context.directory:
                attr |= bold
                fg = blue
            elif context.executable and not \
                    any((context.media, context.container,
                       context.fifo, context.socket)):
                attr |= bold
                fg = green
            if context.socket:
                fg = 180
                attr |= bold
            if context.fifo or context.device:
                fg = 144
                if context.device:
                    attr |= bold
            if context.link:
                fg = context.good and cyan or black
            if context.bad:
                bg = red
            if context.tag_marker and not context.selected:
                attr |= bold
                fg = red
            if not context.selected and (context.cut or context.copied):
                fg = yellow
                bg = 234
            if context.main_column:
                if context.selected:
                    attr |= bold
                if context.marked:
                    attr |= bold
                    fg = red
            if context.badinfo:
                if attr & reverse:
                    bg = 95
                else:
                    fg = 95

        elif context.in_titlebar:
            attr |= bold
            if context.hostname:
                fg = green
            elif context.directory:
                fg = red
            elif context.tab:
                if context.good:
                    bg = blue
            elif context.link:
                fg = red

        elif context.in_statusbar:
            if context.permissions:
                if context.good:
                    fg = green
                elif context.bad:
                    fg = red
            if context.marked:
                attr |= bold | reverse
                fg = 223
            if context.message:
                if context.bad:
                    attr |= bold
                    fg = red
            if context.loaded:
                bg = self.progress_bar_color

        if context.text:
            if context.highlight:
                attr |= reverse

        if context.in_taskview:
            if context.title:
                fg = cyan

            if context.selected:
                attr |= reverse

            if context.loaded:
                if context.selected:
                    fg = self.progress_bar_color
                else:
                    bg = self.progress_bar_color

        return fg, bg, attr
