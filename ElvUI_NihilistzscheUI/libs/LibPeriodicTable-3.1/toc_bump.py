import os
from os.path import join
from pathlib import Path
import argparse
import logging
import re


toc_regex = r"##\s*Interface:\s*\d+"






if __name__ == "__main__":
	logging.basicConfig(filename='toc_bump.log', filemode='w', level=logging.DEBUG)

	parser = argparse.ArgumentParser(description='Bump TOC version of all projects in this directory')
	parser.add_argument('--toc', required=True)

	args = parser.parse_args()

	logging.info('TOC Version:%s', args.toc)

	new_toc_line = "## Interface: " + args.toc

	for dir_name, dirs, file_list in os.walk('.'):
		for fname in file_list:
			extension = os.path.splitext(fname)[1][1:].strip().lower()
			if (extension == "toc") :
				full_path = os.path.join(dir_name, fname)
				logging.info(f"Processing {full_path}")
				contents = Path(full_path).read_text()

				new_contents = re.sub(toc_regex, new_toc_line , contents, 0, re.MULTILINE)
				Path(full_path).write_text(new_contents)

