
omz_downloader --name googlenet-v1-tf

omz_converter --name googlenet-v1-tf

benchmark_app -m public/googlenet-v1-tf/FP32/googlenet-v1-tf.xml -niter 1

mo \
--framework=tf \
--data_type FP32 \
--output_dir ./public/googlenet-v1-tf/FP32 \
--model_name=googlenet-v1-tf \
--input_shape=[1,224,224,3] \
--input_model ./public/googlenet-v1-tf/inception_v1.frozen.pb

## Test Python Imports

python3 -c "from openvino.inference_engine import IENetwork, IECore, get_version as get_ov_version; print('openvino version: ' + get_ov_version())"

python3 -c "from openvino.tools.benchmark.main import main"
