from .model import _Model


class _Architecture(_Model):
    '''
    - Also wrap lpy in its own model?
    - define some convinience functions to query the architecture

    '''
    def __init__(self, **kwargs):
        super().__init__(**kwargs)
