
import os
import re
import subprocess
import sys

class VersionCode(object):
    def __init__(self, *args) -> None:
        super().__init__()
        
        assert len(args) > 0, f'At least one argument is required.'
        
        self.num_code = [ int(a) for a in args ]
        self.str_code = '.'.join([str(c) for c in self.num_code])
        
    def __str__(self) -> str:
        return self.str_code
    
    def _check_comparable(self, other):
        if not isinstance(other, (VersionCode, str)):
            raise Exception('Cannot compare VersionCode with types other than VersionCode or str.')
    
    def __eq__(self, other: object) -> bool:
        self._check_comparable(other)
        return str(self) == str(other)
    
    def __ne__(self, other: object) -> bool:
        self._check_comparable(other)
        return str(self) != str(other)
    
    def __lt__(self, other: object) -> bool:
        self._check_comparable(other)
        return str(self) < str(other)
    
    def __le__(self, other: object) -> bool:
        self._check_comparable(other)
        return str(self) <= str(other)

    def __gt__(self, other: object) -> bool:
        self._check_comparable(other)
        return str(self) > str(other)
    
    def __ge__(self, other: object) -> bool:
        self._check_comparable(other)
        return str(self) >= str(other)
    
    def __getitem__(self, key):
        return self.num_code[key]

def get_cuda_version():
    output = subprocess.run(['nvcc', '--version'], 
                            stdout=subprocess.PIPE,
                            stderr=subprocess.PIPE)
    print(output.stdout.decode())
    print(output.stderr.decode())
    
    if output.returncode != 0:
        raise Exception('Error encountered when running nvcc --version. ')
        
    m = re.search(r'cuda_(\d+\.\d+)', output.stdout.decode())
    assert m is not None, f'Could not parse CUDA version from nvcc --version output.'
    
    # Get the version in integer format.
    ss = m[1].split('.')
    
    return VersionCode(*ss)
    
def get_torch_version():
    import torch
    m = re.search(r"^(\d+\.\d+\.\d+)", torch.__version__)
    ss = m[1].split('.')
    return VersionCode(*ss)

def construct_pyg_archive_code(torch_version: VersionCode, cuda_version: VersionCode):
    '''
    Checkout https://data.pyg.org/whl/
    '''
    pyg_cuda_suffix = ''
    if torch_version == '1.8.0' and cuda_version[0] == 11:
        pyg_cuda_suffix = 'cu111'
    elif torch_version == '1.10.2' and cuda_version[0] == 11 and cuda_version[1] == 3:
        # For debugging.
        pyg_cuda_suffix = 'cu113'
    elif torch_version == '1.12.0' and cuda_version[0] == 11 and cuda_version[1] >= 6:
        pyg_cuda_suffix = 'cu116'
    elif torch_version == '1.13.0' and cuda_version[0] == 11 and cuda_version[1] >= 7:
        pyg_cuda_suffix = 'cu117'
    else:
        raise Exception(f'pyg: Unsupported PyTorch version {torch_version} and CUDA version {cuda_version}. Please check the source code for supported versions. ')
    
    return f'torch-{torch_version}+{pyg_cuda_suffix}'

def construct_cupy_pip_code(cuda_version: VersionCode):
    '''
    Checkout https://docs.cupy.dev/en/stable/install.html
    '''
    cupy_cuda_suffix = ''
    if cuda_version[0] == 11 and cuda_version[1] == 0:
        cupy_cuda_suffix = 'cuda110'
    elif cuda_version[0] == 11 and cuda_version[1] == 1:
        cupy_cuda_suffix = 'cuda111'
    elif cuda_version[0] == 11 and cuda_version[1] >= 2:
        cupy_cuda_suffix = 'cuda11x'
    else:
        raise Exception(f'cupy: Unsupported CUDA version {cuda_version}. Please check the source code for supported versions. ')
    
    return f'cupy-{cupy_cuda_suffix}'

def main():
    # Get the current CUDA version.
    cuda_version = get_cuda_version()
    print(f'cuda_version = {cuda_version}')
    
    torch_version = get_torch_version()
    print(f'torch_version = {torch_version}')
    
    pyg_archive_code = construct_pyg_archive_code(torch_version, cuda_version)
    print(f'pyg_archive_code = {pyg_archive_code}')
    
    cupy_pip_code = construct_cupy_pip_code(cuda_version)
    print(f'cupy_pip_code = {cupy_pip_code}')
    
    HOME = os.environ['HOME']
    print(f'HOME = {HOME}')
    
    # All version checks passed.
    # Write files to ${HOME}.
    with open(os.path.join(HOME, 'version_info.sh'), 'w') as fp:
        fp.write(f'VI_CUDA_VERSION={cuda_version}\n')
        fp.write(f'VI_TORCH_VERSION={torch_version}\n')
        fp.write(f'VI_PYG_ARCHIVE_CODE={pyg_archive_code}\n')
        fp.write(f'VI_CUPY_PIP_CODE={cupy_pip_code}\n')
    
if __name__ == '__main__':
    try:
        main()
    except Exception as exc:
        print('Error encountered: ')
        print(exc)
        sys.exit(1)
        
    sys.exit(0)