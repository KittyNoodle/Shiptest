import { useBackend } from '../backend';
import {
  AnimatedNumber,
  Box,
  Button,
  Dimmer,
  Flex,
  Icon,
  ProgressBar,
  Section,
  Slider,
  Stack,
} from '../components';
import { Window } from '../layouts';

const LockedInterface = () => {
  return (
    <Dimmer>
      <Flex direction="column" textAlign="center" width="300px">
        <Flex.Item>
          <Icon color="yellow" name="lock" size={10} />
        </Flex.Item>

        <Flex.Item fontSize="16px">Gateway interface locked.</Flex.Item>
      </Flex>
    </Dimmer>
  );
};

export const Pandora = (props, context) => {
  const { act, data } = useBackend(context);
  return (
    <Window width={800} height={500} resizable>
      <Window.Content scrollable>
        {data.locked && <LockedInterface />}
        <Stack vertical>
          <Stack.Item>
            <Stack fill>
              <Stack.Item width="100%">
                <Section title="Control Panel">
                  <Button
                    fluid
                    icon={data.active ? 'power-off' : 'times'}
                    onClick={() => act('power')}
                    disabled={!data.integrity}
                    fontSize="48px"
                    textAlign="center"
                    lineHeight="60px"
                    color={data.active ? 'good' : 'blue'}
                  >
                    {data.active ? 'Deactivate' : 'Activate'}
                  </Button>
                  <Button
                    fluid
                    icon={data.output ? 'sign-out-alt' : 'sign-in-alt'}
                    onClick={() => act('output')}
                    disabled={!data.integrity}
                    fontSize="48px"
                    textAlign="center"
                    lineHeight="60px"
                    color={data.output ? 'pink' : 'yellow'}
                  >
                    {data.output ? 'Output' : 'Input'}
                  </Button>
                  <Box color="white" textAlign="center" fontSize="20px">
                    Target Points:
                  </Box>
                  <Box color="white" textAlign="center" fontSize="16px">
                    0.02: Void
                  </Box>
                  <Box color="white" textAlign="center" fontSize="16px">
                    1.04: Wirespace
                  </Box>
                </Section>
              </Stack.Item>
              <Stack.Item width="100%">
                <Section title="Diagnostics">
                  <Box color="white" textAlign="center" fontSize="28px">
                    Gateway Integrity:
                  </Box>
                  <Box
                    color={data.integrity ? 'good' : 'bad'}
                    textAlign="center"
                    fontSize="24px"
                  >
                    {data.integrity ? 'Online' : 'Offline'}
                  </Box>
                  <Box color="grey" textAlign="center" fontSize="20px">
                    Internal Power:
                  </Box>
                  <Box
                    color={data.pandora_powered ? 'good' : 'bad'}
                    textAlign="center"
                    fontSize="16px"
                  >
                    {data.pandora_powered ? 'Online' : 'Offline'}
                  </Box>
                  <Box color="grey" textAlign="center" fontSize="20px">
                    Vacuum State Actuator:
                  </Box>
                  <Box
                    color={data.pandora_vsa ? 'good' : 'bad'}
                    textAlign="center"
                    fontSize="16px"
                  >
                    {data.pandora_vsa ? 'Online' : 'Offline'}
                  </Box>
                  <Box color="grey" textAlign="center" fontSize="20px">
                    Gravitational Field Emitters:
                  </Box>
                  <Box
                    color={data.pandora_field_emitter ? 'good' : 'bad'}
                    textAlign="center"
                    fontSize="16px"
                  >
                    {data.pandora_field_emitter ? 'Online' : 'Offline'}
                  </Box>
                  <Box color="grey" textAlign="center" fontSize="20px">
                    Laser Guidance:
                  </Box>
                  <Box
                    color={data.pandora_guidance ? 'good' : 'bad'}
                    textAlign="center"
                    fontSize="16px"
                  >
                    {data.pandora_guidance ? 'Online' : 'Offline'}
                  </Box>
                </Section>
              </Stack.Item>
            </Stack>
          </Stack.Item>
          <Stack.Item>
            <Section title="Throttle">
              <Slider
                value={data.throttle_target}
                step={0.01}
                stepPixelSize={5}
                maxValue={data.throttle_max}
                minValue={data.throttle_min}
                ranges={{
                  white: [130, Infinity],
                  pink: [10, 130],
                  purple: [1.041, 10],
                  grey: [1.04, 1.04],
                  blue: [0.8, 1.039999],
                  green: [0.6, 0.8],
                  yellow: [0.4, 0.6],
                  orange: [0.2, 0.4],
                  red: [0.021, 0.2],
                  violet: [0.02, 0.02],
                  black: [-Infinity, 0.019999],
                }}
                format={(value) => 'Target: ' + value + 'c = c₁'}
                onChange={(e, value) =>
                  act('throttle', {
                    ref: value,
                  })
                }
              />

              <ProgressBar
                value={data.throttle}
                maxValue={data.throttle_max}
                minValue={data.throttle_min}
                format={(value) => value + 'c = c₁'}
                ranges={{
                  white: [130, Infinity],
                  pink: [10, 130],
                  purple: [1.041, 10],
                  grey: [1.039, 1.041],
                  blue: [0.8, 1.039],
                  green: [0.6, 0.8],
                  yellow: [0.4, 0.6],
                  orange: [0.2, 0.4],
                  red: [0.021, 0.2],
                  violet: [0.019, 0.021],
                  black: [-Infinity, 0.019],
                }}
              >
                <AnimatedNumber
                  value={data.throttle}
                  format={(value) => value.toFixed(2)}
                />
                c = c₁
              </ProgressBar>
            </Section>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
