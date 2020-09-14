from abc import abstractmethod, ABC


class _Model(ABC):

    '''
    Subclasses should implement at least two types of errors
        - InitializationError (wrong input, init parameters)
        - SimulationError (inconsistent values, pools ...)

        can those error classes be part of the _Model namespace?
    '''

    def __init__(self):
        pass

    @property
    @staticmethod
    @abstractmethod
    def id(self) -> str:
        pass

    @property
    @staticmethod
    @abstractmethod
    def timestep(self) -> int:
        '''
        Each Model might have a different timestep
        can this vary? is there a minimum or preferred timestep?
        How does this relate to parameters/settings?
        '''
        pass

    @property
    @abstractmethod
    def parameters(self):
        pass

    @property
    @abstractmethod
    def options(self):
        '''
        Each Model implements options for optional subprocesses
        How does this relate to parameters/settings?
        '''
        pass

    @property
    @abstractmethod
    def output(self):
        '''
        Define the output of the model with names and units
        '''
        pass
