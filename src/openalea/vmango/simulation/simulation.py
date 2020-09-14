from ..base._simulation import _Simulation
from .model.architecture.architecture import Architecture
from .model.photosynthesis.photosynthesis import Photosynthesis


'''
    - start / end of a simulation
    - is it possible to req. the initial architecture for "any" start date?
    - define datastructure


'''


class Simulation(_Simulation):

    def __init__(self, **kwargs):
        super().__init__(**kwargs)
        pass

    @property
    def model_stack(self):
        '''
            - ordering of models (hardcode?)
            - define mandatory and optional models?
            -

        '''
        return [
            Architecture,
            Photosynthesis
        ]

    def initialize(self):
        pass

    def run(self):
        pass
