from ....base.base_photosynthesis import _Photosynthesis
from ....base.base_simulation import register


@register
class Photosynthesis(_Photosynthesis):

    def __init__(self, **kwargs):
        super().__init__(**kwargs)
        pass
