from ....base._architecture import _Architecture
from ....base._simulation import register


@register
class Architecture(_Architecture):

    def __init__(self, **kwargs):
        super().__init__(**kwargs)
        pass
