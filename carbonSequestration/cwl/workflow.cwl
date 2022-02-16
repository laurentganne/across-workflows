cwlVersion: v1.2
class: Workflow
inputs:
  dataset_url: string
  dataset_name: string
  input_deck: string
outputs:
  results:
    type: File[]
    outputSource: opmflow/flow_output
steps:
  download:
    run: ../../common/cwl/download_url.cwl
    in:
      input_url: dataset_url
      input_file_name: dataset_name
    out: [downloaded_file]
  unzip:
    run: ../../common/cwl/unzip.cwl
    in:
      input_file: download/downloaded_file
    out: [unzipped_files]
  opmflow:
    run:
      class: CommandLineTool
      baseCommand: ['flow']
      requirements:
        InitialWorkDirRequirement:
          listing:          
            - $(inputs.input_files)
      stdout: output_flow.log
      arguments:
        - position: 1
          valueFrom: '--output-dir=$(runtime.outdir)/output'
        - position: 2
          valueFrom: '$(runtime.outdir)/$(inputs.input_deck_path)'
      inputs:
        input_files:
          type: File[]
        input_deck_path:
          type: string
      outputs:
        flow_output:
          type: File[]
          outputBinding:  
              glob: "output*"
    in:
      input_files: unzip/unzipped_files
      input_deck_path: input_deck
    out: [flow_output]
