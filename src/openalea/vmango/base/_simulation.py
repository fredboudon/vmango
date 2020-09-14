import typing
from abc import abstractmethod, ABC
from ._model import _Model


def register(cls):
    _Simulation.model_registry.register(cls)
    return cls


class ModelRegistry():

    def __init__(self):
        pass

    def register(model: typing.Type[_Model]):
        pass


class _Simulation(ABC):

    model_registry = ModelRegistry()
    '''
        - initialisation
            - load parameters, input files
            - initialize models and pools
            - run any required preparatory steps e.g. glm
        -
    '''
    def __init__(self, filename):
        self.__parse(filename)
        pass

    def __parse(self, filename):
        '''
        - parse toml files
        - instantiate selected models
        - pass params to models
        '''
        pass

    @property
    @abstractmethod
    def model_stack(self):
        pass

    @abstractmethod
    def initialize(self):
        pass

    @abstractmethod
    def run(self):
        pass
