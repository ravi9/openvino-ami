
omz_downloader --name googlenet-v1-tf

omz_converter --name googlenet-v1-tf

benchmark_app -m public/googlenet-v1-tf/FP32/googlenet-v1-tf.xml

mo \
--framework=tf \
--data_type FP32 \
--output_dir ./public/googlenet-v1-tf/FP32 \
--model_name=googlenet-v1-tf \
--input_shape=[1,224,224,3] \
--input_model ./public/googlenet-v1-tf/inception_v1.frozen.pb
